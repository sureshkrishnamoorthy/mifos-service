/**

 * TaskHelper.java    version: 1.0



 * Copyright (c) 2005-2006 Grameen Foundation USA

 * 1029 Vermont Avenue, NW, Suite 400, Washington DC 20005

 * All rights reserved.



 * Apache License
 * Copyright (c) 2005-2006 Grameen Foundation USA
 *

 * Licensed under the Apache License, Version 2.0 (the "License"); you may
 * not use this file except in compliance with the License. You may obtain
 * a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
 *

 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and limitations under the

 * License.
 *
 * See also http://www.apache.org/licenses/LICENSE-2.0.html for an explanation of the license

 * and how it is applied.

 *

 */

package org.mifos.framework.components.cronjobs;

import java.sql.Timestamp;

import org.hibernate.Query;
import org.hibernate.Session;
import org.mifos.framework.components.cronjobs.business.Task;
import org.mifos.framework.components.cronjobs.exceptions.CronJobException;
import org.mifos.framework.components.cronjobs.helpers.TaskStatus;
import org.mifos.framework.components.cronjobs.persistence.TaskPersistence;
import org.mifos.framework.components.logger.LoggerConstants;
import org.mifos.framework.components.logger.MifosLogManager;
import org.mifos.framework.components.logger.MifosLogger;
import org.mifos.framework.exceptions.PersistenceException;
import org.mifos.framework.hibernate.helper.HibernateUtil;

public abstract class TaskHelper {

	private MifosTask mifosTask;

	private Task task;

	long timeInMillis = 0;
	
	private MifosLogger logger;

	public TaskHelper(MifosTask mifosTask) {
		this.mifosTask = mifosTask;
		this.logger = MifosLogManager.getLogger(LoggerConstants.CRONJOBS);
	}
	
	protected MifosLogger getLogger() {
		return logger;
	}

	/**
	 * This method is responsible for inserting a row with the task name in the
	 * database. In cases that the task fails, the next day's task will not run
	 * till the completion of the previous day's task.
	 */
	public final void registerStartup(long timeInMillis)
			throws CronJobException {
		try {
			MifosTask.cronJobStarted();
			task = new Task();
			task.setDescription(SchedulerConstants.START);
			task.setTask(mifosTask.name);
			task.setStatus(TaskStatus.INCOMPLETE);
			if (timeInMillis == 0) {
				task.setStartTime(new Timestamp(System.currentTimeMillis()));
			} else {
				task.setStartTime(new Timestamp(timeInMillis));
			}
			new TaskPersistence().saveAndCommitTask(task);
		} catch (PersistenceException e) {
			throw new CronJobException(e);
		}
	}

	/**
	 * This method is responsible for inserting a row with the task name in the
	 * database, at end of task completion. In cases where the task fails, the
	 * next day's task will not run till the completion of th previous day's
	 * task.
	 */
	public final void registerCompletion(long timeInMillis, String description,
			TaskStatus status) {
		try {
			task.setDescription(description);
			task.setStatus(status);
			if (timeInMillis == 0) {
				task.setEndTime(new Timestamp(System.currentTimeMillis()));
			} else {
				task.setEndTime(new Timestamp(timeInMillis));
			}
			new TaskPersistence().saveAndCommitTask(task);
		} catch (PersistenceException e) {
			MifosLogManager.getLogger(LoggerConstants.FRAMEWORKLOGGER).error(
					"Cron job task " + mifosTask.name + " failed");
		} finally {
			MifosTask.cronJobFinished();
		}
	}

	/**
	 * This method is called by run method of Mifostask. This calls
	 * registerStartUP,istaksAllowedToRun, execute and registerCompletion in the
	 * order. The class also ensures that no exception is thrown up.
	 */
	public final void executeTask() {
		if (!isTaskAllowedToRun()) {
			while ((System.currentTimeMillis() - timeInMillis)
					/ (1000 * 60 * 60 * 24) != 1) {
				perform(timeInMillis + (1000 * 60 * 60 * 24));
				timeInMillis +=  (1000 * 60 * 60 * 24);
			}
		} else {
			if (timeInMillis == 0) {
				timeInMillis = System.currentTimeMillis();
			}
			perform(timeInMillis);
		}
	}

	/**
	 * This methods, performs the job specific to each task.
	 */
	public abstract void execute(long timeInMillis) throws CronJobException;

	/**
	 * This method determines if the task is allowed to run the nextday.if the
	 * previous day's task has failed, the default mplementation suspends the
	 * current day's task and runs the previous days task.
	 * 
	 * Override this method and return true, if it is not mandatory that task
	 * should run daily i.e. In case yesterday's task has failed, you want it to
	 * continue running current days task.
	 * 
	 */
	public boolean isTaskAllowedToRun() {
		try {
			Session session = HibernateUtil.getSessionTL();
			HibernateUtil.startTransaction();
			String hqlSelect = "select max(t.startTime) from Task t "
					+ "where t.task=:taskName and t.description=:finishedSuccessfully";
			Query query = session.createQuery(hqlSelect);
			query.setString("taskName", mifosTask.name);
			query.setString("finishedSuccessfully",
					SchedulerConstants.FINISHED_SUCCESSFULLY);
			if (query.uniqueResult() == null) {
				// When schedular starts for the first time
				timeInMillis = System.currentTimeMillis();
				return true;
			} else {
				timeInMillis = ((Timestamp) query.uniqueResult()).getTime();
			}
			HibernateUtil.commitTransaction();
			if ((System.currentTimeMillis() - timeInMillis)
					/ (1000 * 60 * 60 * 24) <= 1) {
				timeInMillis = System.currentTimeMillis();
				return true;
			}
			return false;
		} catch (Exception e) {
			return true;
		}
	}

	private void perform(long timeInMillis) {
		try {
			registerStartup(timeInMillis);
			execute(timeInMillis);
			registerCompletion(0, SchedulerConstants.FINISHED_SUCCESSFULLY,
					TaskStatus.COMPLETE);
		} catch (CronJobException e) {
			registerCompletion(timeInMillis, e.getErrorMessage(),
					TaskStatus.INCOMPLETE);
		}
	}
}
