/*
 * Copyright (c) 2005-2010 Grameen Foundation USA
 * All rights reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
 * implied. See the License for the specific language governing
 * permissions and limitations under the License.
 *
 * See also http://www.apache.org/licenses/LICENSE-2.0.html for an
 * explanation of the license and how it is applied.
 */

package org.mifos.platform.accounting.service;

import java.util.ArrayList;
import java.util.List;

import org.joda.time.LocalDate;
import org.mifos.platform.accounting.AccountingDto;
import org.mifos.platform.accounting.dao.IAccountingDao;
import org.mifos.platform.accounting.tally.TallyXMLGenerator;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class AccountingServiceImpl implements IAccountingService {

    private final AccountingDataCacheManager cacheManager;

    private final IAccountingDao accountingDao;

    @Autowired
    public AccountingServiceImpl(AccountingDataCacheManager cacheManager, IAccountingDao accountingDao) {
        this.cacheManager = cacheManager;
        this.accountingDao = accountingDao;
    }

    @Override
    public final String getTallyOutputFor(LocalDate startDate, LocalDate endDate) {
        String fileName = getTallyOutputFileName(startDate, endDate);

        List<AccountingDto> accountingData = getAccountingDataFor(startDate, endDate);

        String output = "NO DATA";
        if (!accountingData.isEmpty()) {
            output = TallyXMLGenerator.getTallyXML(accountingData, fileName);
        }
        return output;
    }

    @Override
    public final List<AccountingDto> getAccountingDataFor(LocalDate startDate, LocalDate endDate) {
        String fileName = cacheManager.getCacheFileName(startDate, endDate);
        if (!cacheManager.isAccountingDataAlreadyInCache(fileName)) {
            if(!writeToCache(startDate, endDate)) {
                return new ArrayList<AccountingDto>();
            }
        }
        return cacheManager.getAccoutingDataFromCache(fileName);
    }

    private boolean writeToCache(LocalDate startDate, LocalDate endDate) {
        List<AccountingDto> accountingData = accountingDao.getAccountingDataByDate(startDate, endDate);
        if (!accountingData.isEmpty()) {
            cacheManager.writeAccountingDataToCache(accountingData, cacheManager.getCacheFileName(startDate, endDate));
            return true;
        }
        return false;
    }

    @Override
    public final String getTallyOutputFileName(LocalDate startDate, LocalDate endDate) {
        return cacheManager.getTallyOutputFileName(startDate, endDate);
    }

    @Override
    public final List<AccountingCacheFileInfo> getAccountingDataCacheInfo() {
        return cacheManager.getAccountingDataCacheInfo();
    }

    @Override
    public final Boolean deleteCacheDir() {
        return cacheManager.deleteCacheDir();
    }

    @Override
    public final Boolean hasAlreadyRanQuery(LocalDate startDate, LocalDate endDate) {
        String fileName = cacheManager.getCacheFileName(startDate, endDate);
        return cacheManager.isAccountingDataAlreadyInCache(fileName);
    }

}
