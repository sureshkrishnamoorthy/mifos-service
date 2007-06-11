<!--
 
 * loanaccountdetail.jsp  version: xxx
 
 
 
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
 
 -->

<%@taglib uri="/tags/struts-html" prefix="html"%>
<%@taglib uri="/tags/struts-bean" prefix="bean"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="/tags/mifos-html" prefix="mifos"%>
<%@taglib uri="/tags/struts-html-el" prefix="html-el"%>
<%@ taglib uri="/tags/struts-tiles" prefix="tiles"%>
<%@ taglib uri="/mifos/customtags" prefix="mifoscustom"%>
<%@ taglib uri="/loan/loanfunctions" prefix="loanfn"%>
<%@ taglib uri="/userlocaledate" prefix="userdatefn"%>
<%@ taglib uri="/mifos/custom-tags" prefix="customtags"%>
<%@ taglib uri="/sessionaccess" prefix="session"%>
<tiles:insert definition=".clientsacclayoutsearchmenu">
	<tiles:put name="body" type="string">
		<html-el:form method="post" action="/loanAccountAction.do">
		<c:set value="${session:getFromSession(sessionScope.flowManager,requestScope.currentFlowKey,'BusinessKey')}" var="BusinessKey" />
		<c:set value="${session:getFromSession(sessionScope.flowManager,requestScope.currentFlowKey,'lastPaymentAction')}" var="lastPaymentAction" />
		<html-el:hidden property="currentFlowKey" value="${requestScope.currentFlowKey}" />	
			<table width="95%" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td class="bluetablehead05">
						<span class="fontnormal8pt"> <customtags:headerLink selfLink="false" /> </span>
					</td>
				</tr>
			</table>
			<table width="95%" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td width="70%" align="left" valign="top" class="paddingL15T15">
						<table width="96%" border="0" cellpadding="3" cellspacing="0">
							<tr>
								<td width="62%" class="headingorange">
									<c:out value="${BusinessKey.loanOffering.prdOfferingName}" />&nbsp;#
									<c:out value="${BusinessKey.globalAccountNum}" /> <br>
								</td>
								<td width="38%" rowspan="2" align="right" valign="top" class="fontnormal">
									<c:if test="${BusinessKey.accountState.id != 6 and BusinessKey.accountState.id != 7 and BusinessKey.accountState.id !=8 and BusinessKey.accountState.id !=10}">
										<html-el:link href="editStatusAction.do?method=load&accountId=${BusinessKey.accountId}&randomNUm=${sessionScope.randomNUm}&currentFlowKey=${requestScope.currentFlowKey}">
											<mifos:mifoslabel name="loan.edit_acc_status" />
										</html-el:link>
									</c:if><br>
								</td>
							</tr>
						</table>
						<table width="100%" border="0" cellpadding="3" cellspacing="0">
							<tr>
								<td>
									<font class="fontnormalRedBold"><html-el:errors	bundle="loanUIResources" /></font>
								</td>
							</tr>
						</table>
						<table width="96%" border="0" cellpadding="0" cellspacing="0">
							<tr>
								<td class="fontnormalbold">
									<span class="fontnormal">
										<mifoscustom:MifosImage	id="${BusinessKey.accountState.id}" moduleName="accounts" />
										<c:out value="${BusinessKey.accountState.name}" />&nbsp; 
										<c:forEach var="flagSet" items="${BusinessKey.accountFlags}">
											<span class="fontnormal"><c:out value="${flagSet.flag.name}" /></span>
										</c:forEach> 
									</span>
								</td>
							</tr>
							<tr>
								<td class="fontnormal">
									<mifos:mifoslabel name="loan.proposed_date" />: 
									<c:out value="${userdatefn:getUserLocaleDate(sessionScope.UserContext.preferredLocale,BusinessKey.disbursementDate)}" />
								</td>
							</tr>
							<tr id="Loan.PurposeOfLoan">
								<td class="fontnormal">
									<mifos:mifoslabel name="loan.business_work_act" keyhm="Loan.PurposeOfLoan" isManadatoryIndicationNotRequired="yes"/>
									<mifos:mifoslabel name="${ConfigurationConstants.LOAN}" isColonRequired="yes"/>
									<c:forEach var="busId" items="${session:getFromSession(sessionScope.flowManager,requestScope.currentFlowKey,'BusinessActivities')}" >
										<c:if test="${busId.id eq BusinessKey.businessActivityId}">
											<c:out value="${busId.name}" />
										</c:if>
									</c:forEach>
								</td>
							</tr>
						</table>
						<table width="50%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td><img src="pages/framework/images/trans.gif" width="10" height="10"></td>
							</tr>
						</table>
						<table width="96%" border="0" cellpadding="3" cellspacing="0">
							<tr>
								<td width="33%" class="headingorange">
									<mifos:mifoslabel name="loan.acc_summary" />
								</td>
								<td width="33%" align="right" class="fontnormal">
									<html-el:link href="loanAccountAction.do?method=getLoanRepaymentSchedule&input=reviewTransactionPage&accountId=${BusinessKey.accountId}&prdOfferingName=${BusinessKey.loanOffering.prdOfferingName}&globalAccountNum=${BusinessKey.globalAccountNum}&accountType=${BusinessKey.accountType.accountTypeId}&accountStateId=${BusinessKey.accountState.id}&recordOfficeId=${BusinessKey.office.officeId}&recordLoanOfficerId=${BusinessKey.personnel.personnelId}&lastPaymentAction=${lastPaymentAction}&randomNUm=${sessionScope.randomNUm}&currentFlowKey=${requestScope.currentFlowKey}">
										<mifos:mifoslabel name="loan.view_schd" />
									</html-el:link>
								</td>
							</tr>
						</table>
						<c:if test="${BusinessKey.accountState.id == 5 || BusinessKey.accountState.id == 9}">
							<table width="96%" border="0" cellpadding="3" cellspacing="0">
								<tr>
									<td width="58%" class="fontnormal">
										<mifos:mifoslabel name="loan.totalAmtDue" />
										<c:out value="${userdatefn:getUserLocaleDate(sessionScope.UserContext.preferredLocale,BusinessKey.nextMeetingDate)}" />:
										<c:out value="${BusinessKey.totalAmountDue}" />
									</td>
									<%--<span
										class="fontnormal"><a href="nextPayment_loanAccount.htm"><mifos:mifoslabel name="loan.view_inst_details" /></a></span><a href="#"><span
										class="fontnormalbold"> </span></a>--%>
									<%--<c:if test="${BusinessKey.accountStateId == 5 || BusinessKey.accountStateId == 9}">
									<td width="42%" align="right" class="fontnormal">
										<span class="fontnormal"><html-el:link href="loanAction.do?method=getInstallmentDetails&accountId=${BusinessKey.accountId}&accountName=${BusinessKey.loanOffering.prdOfferingName}&globalAccountNum=${BusinessKey.globalAccountNum}
																&accountType=${BusinessKey.accountTypeId}
																&accountStateId=${BusinessKey.accountStateId}
																&recordOfficeId=${BusinessKey.officeId}
																&recordLoanOfficerId=${BusinessKey.personnelId}&randomNUm=${sessionScope.randomNUm}&currentFlowKey=${requestScope.currentFlowKey}"> 
											<mifos:mifoslabel name="loan.view_installment_details" /></span>
										</html-el:link>
									</td>
	              				  </c:if>--%>
								</tr>
								<tr>
									<td colspan="2" class="fontnormal">
										<mifos:mifoslabel name="loan.arrear" />:
										<c:out value="${BusinessKey.totalAmountInArrears}" />
									</td>
								</tr>
							</table>
						</c:if>
						<c:if test="${BusinessKey.accountState.id == 5 || BusinessKey.accountState.id == 9}">
							<table width="96%" border="0" cellpadding="3" cellspacing="0">
				            	<tr>		                
				                	<td width="42%" align="right" class="fontnormal">
				                		<span class="fontnormal">
						                  	<html-el:link href="loanAccountAction.do?method=getInstallmentDetails&accountId=${BusinessKey.accountId}&prdOfferingName=${BusinessKey.loanOffering.prdOfferingName}&globalAccountNum=${BusinessKey.globalAccountNum}&accountType=${BusinessKey.accountType.accountTypeId}&accountStateId=${BusinessKey.accountState.id}&recordOfficeId=${BusinessKey.office.officeId}&recordLoanOfficerId=${BusinessKey.personnel.personnelId}&lastPaymentAction=${lastPaymentAction}&randomNUm=${sessionScope.randomNUm}&currentFlowKey=${requestScope.currentFlowKey}"> 
												<mifos:mifoslabel name="loan.view_installment_details" />								
											</html-el:link>
										</span>
					            	</td>
				                </tr>		               
				            </table>
			            </c:if>
						<table width="96%" border="0" cellpadding="3" cellspacing="0">
							<tr class="drawtablerow">
								<td width="24%">&nbsp;</td>
								<td width="20%" align="right" class="drawtablerowboldnoline">
									<mifos:mifoslabel name="loan.original_loan" />
									<mifos:mifoslabel name="${ConfigurationConstants.LOAN}"/>
								</td>
								<td width="28%" align="right" class="drawtablerowboldnoline">
									<mifos:mifoslabel name="loan.amt_paid" />
								</td>
								<td width="28%" align="right" class="drawtablerowboldnoline">
									<mifos:mifoslabel name="${ConfigurationConstants.LOAN}"/>
									<mifos:mifoslabel name="loan.loan_balance" />
								</td>
							</tr>
							<tr>
								<td class="drawtablerow">
									<mifos:mifoslabel name="loan.principal" />
								</td>
								<td align="right" class="drawtablerow">
									<c:out value="${BusinessKey.loanSummary.originalPrincipal}" />
								</td>
								<td align="right" class="drawtablerow">
									<c:out value="${BusinessKey.loanSummary.principalPaid}" />
								</td>
								<td align="right" class="drawtablerow">
									<c:out value="${BusinessKey.loanSummary.principalDue}" />
								</td>
							</tr>
							<tr>
								<td class="drawtablerow"><mifos:mifoslabel name="${ConfigurationConstants.INTEREST}" /></td>
								<td align="right" class="drawtablerow"><c:out
									value="${BusinessKey.loanSummary.originalInterest}" /></td>
								<td align="right" class="drawtablerow"><c:out
									value="${BusinessKey.loanSummary.interestPaid}" /></td>
								<td align="right" class="drawtablerow"><c:out
									value="${BusinessKey.loanSummary.interestDue}" /></td>
							</tr>
							<tr>
								<td class="drawtablerow"><mifos:mifoslabel name="loan.fees" /></td>
								<td align="right" class="drawtablerow"><c:out
									value="${BusinessKey.loanSummary.originalFees}" /></td>
								<td align="right" class="drawtablerow"><c:out
									value="${BusinessKey.loanSummary.feesPaid}" /></td>
								<td align="right" class="drawtablerow"><c:out
									value="${BusinessKey.loanSummary.feesDue}" /></td>
							</tr>
							<tr>
								<td class="drawtablerow"><mifos:mifoslabel name="loan.penalty" /></td>
								<td align="right" class="drawtablerow"><c:out
									value="${BusinessKey.loanSummary.originalPenalty}" /></td>
								<td align="right" class="drawtablerow"><c:out
									value="${BusinessKey.loanSummary.penaltyPaid}" /></td>
								<td align="right" class="drawtablerow"><c:out
									value="${BusinessKey.loanSummary.penaltyDue}" /></td>
							</tr>
							<tr>
								<td class="drawtablerow"><mifos:mifoslabel name="loan.total" /></td>
								<td align="right" class="drawtablerow"><c:out
									value="${BusinessKey.loanSummary.totalLoanAmnt}" /></td>
								<td align="right" class="drawtablerow"><c:out
									value="${BusinessKey.loanSummary.totalAmntPaid}" /></td>
								<td align="right" class="drawtablerow"><c:out
									value="${BusinessKey.loanSummary.totalAmntDue}" /></td>
							</tr>
							<tr>
								<td colspan="4">&nbsp;</td>
							</tr>
						</table>
						<table width="96%" border="0" cellpadding="3" cellspacing="0">
							<tr>
								<td width="35%" class="headingorange">
									<c:if test="${BusinessKey.accountState.id == 3 || BusinessKey.accountState.id == 4 || BusinessKey.accountState.id == 5
									 || BusinessKey.accountState.id == 6 || BusinessKey.accountState.id == 7 || BusinessKey.accountState.id == 8 || BusinessKey.accountState.id == 9}">
										<mifos:mifoslabel name="loan.recentActivity" />
									</c:if>	
								</td>
								<td width="65%" align="right" class="fontnormal">&nbsp; 
									<c:if test="${!empty BusinessKey.loanActivityDetails}">
										<html-el:link
											href="loanAccountAction.do?method=getAllActivity&accountId=${BusinessKey.accountId}&prdOfferingName=${BusinessKey.loanOffering.prdOfferingName}&accountStateId=${BusinessKey.accountState.id}&globalAccountNum=${BusinessKey.globalAccountNum}&lastPaymentAction=${lastPaymentAction}&accountType=${BusinessKey.accountType.accountTypeId}&randomNUm=${sessionScope.randomNUm}&currentFlowKey=${requestScope.currentFlowKey}">
											<mifos:mifoslabel name="loan.view_acc_activity" />
										</html-el:link>
									</c:if>
								</td>
							</tr>
						</table>
						<c:if test="${BusinessKey.accountState.id == 3 || BusinessKey.accountState.id == 4 || BusinessKey.accountState.id == 5
									 || BusinessKey.accountState.id == 6 || BusinessKey.accountState.id == 7 || BusinessKey.accountState.id == 8 || BusinessKey.accountState.id == 9}">
							<mifoscustom:mifostabletag source="recentAccountActivities"
								scope="session" xmlFileName="RecentAccountActivity.xml"
								moduleName="accounts/loan" passLocale="true" />
						<table width="96%" border="0" cellpadding="3" cellspacing="0">
							<tr>
								<td colspan="3">&nbsp;</td>
							</tr>
						</table>
						</c:if>
					<table width="96%" border="0" cellpadding="3" cellspacing="0">
						<tr>
							<td width="69%" class="headingorange"><mifos:mifoslabel
								name="loan.acc_details" /></td>
							<td width="31%" align="right" valign="top" class="fontnormal"><c:if
								test="${BusinessKey.accountState.id != 6 && BusinessKey.accountState.id != 7 && BusinessKey.accountState.id !=8 && BusinessKey.accountState.id !=10}">
								<html-el:link
									action="loanAccountAction.do?method=manage&globalAccountNum=${BusinessKey.globalAccountNum}&randomNUm=${sessionScope.randomNUm}&currentFlowKey=${requestScope.currentFlowKey}">
									<mifos:mifoslabel name="loan.edit_acc_info" />
								</html-el:link>
							</c:if></td>
						</tr>
						<tr>
							<td height="23" colspan="2" class="fontnormal"><span
								class="fontnormalbold">
								<mifos:mifoslabel name="${ConfigurationConstants.INTEREST}" />
								<mifos:mifoslabel
								name="loan.interestRules" /></span> <span class="fontnormal"><br>
							<mifos:mifoslabel name="${ConfigurationConstants.INTEREST}" />	
							<mifos:mifoslabel name="loan.interest_type" />:&nbsp;
							
							<c:out value="${BusinessKey.interestType.name}" />
							<br>
							<mifos:mifoslabel name="${ConfigurationConstants.INTEREST}" />
							<mifos:mifoslabel name="loan.int_rate" />:&nbsp;<span
								class="fontnormal"><c:out
								value="${BusinessKey.interestRate}" />%&nbsp;<mifos:mifoslabel
								name="loan.apr" /> </span><br>
							</span> 
							<mifos:mifoslabel name="${ConfigurationConstants.INTEREST}" />
							<mifos:mifoslabel name="loan.interest_disb" />:<c:choose>
								<c:when test="${BusinessKey.interestDeductedAtDisbursement}">
									<mifos:mifoslabel name="loan.yes" />
								</c:when>
								<c:otherwise>
									<mifos:mifoslabel name="loan.no" />
								</c:otherwise>
							</c:choose><br>
							<br>
							<span class="fontnormalbold"> <mifos:mifoslabel
								name="loan.repaymentRules" /> </span><br>
							<mifos:mifoslabel name="loan.freq_of_inst" />:&nbsp;<c:out
								value="${BusinessKey.loanOffering.loanOfferingMeeting.meeting.meetingDetails.recurAfter}" />
							<c:choose>
								<c:when
									test="${BusinessKey.loanOffering.loanOfferingMeeting.meeting.meetingDetails.recurrenceType.recurrenceId == '1'}">
									<mifos:mifoslabel name="loan.week(s)" />
								</c:when>
								<c:otherwise>
									<mifos:mifoslabel name="loan.month(s)" />
								</c:otherwise>
							</c:choose> <br>
							<mifos:mifoslabel name="loan.principle_due" />:<c:choose>
								<c:when
									test="${BusinessKey.loanOffering.prinDueLastInst == true}">
									<mifos:mifoslabel name="loan.yes" />
								</c:when>
								<c:otherwise>
									<mifos:mifoslabel name="loan.no" />
								</c:otherwise>
							</c:choose> <br>
							<mifos:mifoslabel name="loan.grace_period_type" />:&nbsp;
							<c:out value="${BusinessKey.gracePeriodType.name}" /><br>
							<mifos:mifoslabel name="loan.no_of_inst" />:&nbsp;<c:out
								value="${BusinessKey.noOfInstallments}" /> <mifos:mifoslabel
								name="loan.allowed_no_of_inst" />&nbsp;<c:out
								value="${BusinessKey.loanOffering.minNoInstallments}" />
							-&nbsp;<c:out
								value="${BusinessKey.loanOffering.maxNoInstallments}" />)<br>
							<mifos:mifoslabel name="loan.grace_period" />:&nbsp;<c:out
								value="${BusinessKey.gracePeriodDuration}" />&nbsp;<mifos:mifoslabel
								name="loan.inst" /><br>
							<mifos:mifoslabel name="loan.source_fund" />:&nbsp;
							<c:out value="${BusinessKey.fund.fundName}" /><br>
						</td>
						</tr>
					</table>
					<table width="96%" border="0" cellpadding="0" cellspacing="0">
						<tr id="collateral">
							<td class="fontnormal"><br>
							<span class="fontnormalbold"><mifos:mifoslabel
								name="loan.collateralDetails" /></span>
						</td>
						</tr>
						<tr id="Loan.CollateralType">
							<td class="fontnormal">
								<mifos:mifoslabel name="loan.collateral_type" keyhm="Loan.CollateralType" isColonRequired="yes" isManadatoryIndicationNotRequired="yes"/>&nbsp;
								<c:out value="${BusinessKey.collateralType.name}" />
							</td>
						</tr>
						<tr id="Loan.CollateralNotes">
							<td class="fontnormal">
							<br>
							<mifos:mifoslabel name="loan.collateral_notes" keyhm="Loan.CollateralNotes" isColonRequired="yes" isManadatoryIndicationNotRequired="yes"/>&nbsp;<br>
							<c:out value="${BusinessKey.collateralNote}" />
						</td>
						</tr>
						<script>
							if(document.getElementById("Loan.CollateralType").style.display=="none" &&
								document.getElementById("Loan.CollateralNotes").style.display=="none")
									document.getElementById("collateral").style.display="none";
						</script>
						<tr>
							<td class="fontnormal"><br>
							<c:if test="${!empty session:getFromSession(sessionScope.flowManager,requestScope.currentFlowKey,'customFields')}">
							<span class="fontnormalbold"><mifos:mifoslabel
								name="loan.additionalInfo" /><br></span> <span class="fontnormal">
								<c:forEach var="cfdef" items="${session:getFromSession(sessionScope.flowManager,requestScope.currentFlowKey,'customFields')}">
									<c:forEach var="cf" items="${BusinessKey.accountCustomFields}">
										<c:if test="${cfdef.fieldId==cf.fieldId}">
											<span class="fontnormal"> <mifos:mifoslabel name="${cfdef.lookUpEntity.entityType}"></mifos:mifoslabel>: <c:out value="${cf.fieldValue}" /> </span>
											<br>
										</c:if>
									</c:forEach>
								</c:forEach>
							</span> <br>
							</c:if>
							<span class="fontnormalbold"> <mifos:mifoslabel
								name="loan.recurring_acc_fees" /><br>
							</span> <c:forEach items="${BusinessKey.accountFees}" var="feesSet">
								<c:if
									test="${feesSet.fees.feeFrequency.feeFrequencyType.id == '1' && feesSet.feeStatus != '2'}">
									<c:out value="${feesSet.fees.feeName}" />:
										<span class="fontnormal"> <c:out
										value="${feesSet.accountFeeAmount}" />&nbsp;( <mifos:mifoslabel
										name="loan.periodicityTypeRate" /> <c:out
										value="${loanfn:getMeetingRecurrence(feesSet.fees.feeFrequency.feeMeetingFrequency,sessionScope.UserContext)}" />)
									<html-el:link
										href="accountAppAction.do?method=removeFees&feeId=${feesSet.fees.feeId}&globalAccountNum=${BusinessKey.globalAccountNum}&accountId=${BusinessKey.accountId}&recordOfficeId=${BusinessKey.office.officeId}&recordLoanOfficerId=${BusinessKey.personnel.personnelId}&createdDate=${BusinessKey.createdDate}&randomNUm=${sessionScope.randomNUm}&currentFlowKey=${requestScope.currentFlowKey}&input=Loan"> 
														<mifos:mifoslabel name="loan.remove" />
										    </html-el:link> <br>
									</span>
								</c:if>
							</c:forEach><br>
							<%--	<span class="fontnormal"><a href="loan_account_detail_partial.htm">Detail
										- partial/pending/cancelled</a><br>
										<a href="loan_account_detail_closed.htm">Detail - closed</a></span>
										<br> --%></td>
						</tr>
					</table>
					<table width="96%" border="0" cellpadding="3" cellspacing="0">
						<tr>
							<td width="66%" class="headingorange"><mifos:mifoslabel
								name="loan.more_details" /></td>
						</tr>
						<tr>
							<td class="fontnormal"><%--
									<html-el:link href="transaction_history_loanAccount.htm"> <mifos:mifoslabel name="loan.view_transc_history" />
									</html-el:link><br>--%> <span class="fontnormal"> 
							<html-el:link href="loanAccountAction.do?method=viewStatusHistory&globalAccountNum=${BusinessKey.globalAccountNum}&randomNUm=${sessionScope.randomNUm}&currentFlowKey=${requestScope.currentFlowKey}">
								<mifos:mifoslabel name="loan.view_status_history" />
							</html-el:link><br>
								<html-el:link href="loanAccountAction.do?method=loadChangeLog&entityType=Loan&entityId=${BusinessKey.accountId}&currentFlowKey=${requestScope.currentFlowKey}">
								<mifos:mifoslabel name="loan.view_change_log" />
							</html-el:link><br>
							<html-el:link href="accountAppAction.do?method=getTrxnHistory&input=LoanDetails&globalAccountNum=${BusinessKey.globalAccountNum}&accountId=${BusinessKey.accountId}&prdOfferingName=${BusinessKey.loanOffering.prdOfferingName}&randomNUm=${sessionScope.randomNUm}&currentFlowKey=${requestScope.currentFlowKey}">
                    	<mifos:mifoslabel name="Center.TransactionHistory" />
                    	</html-el:link>
							 </span></td>
						</tr>
					</table>
					</td>
					<td width="30%" align="left" valign="top" class="paddingleft1">
					<table width="100%" border="0" cellpadding="2" cellspacing="0"
						class="orangetableborder">
						<tr>
							<td class="orangetablehead05"><span class="fontnormalbold"><mifos:mifoslabel
								name="loan.trxn" /></span></td>
						</tr>
						<tr>
							<td class="paddingL10"><c:choose>
								<c:when
									test="${BusinessKey.accountState.id=='5' || BusinessKey.accountState.id=='7' || BusinessKey.accountState.id=='8' || BusinessKey.accountState.id=='9'}">
									<span class="fontnormal8pt"> 
										<c:if test="${(BusinessKey.accountState.id=='5' || BusinessKey.accountState.id=='9')}">
											<html-el:link href="applyPaymentAction.do?method=load&input=loan&prdOfferingName=${BusinessKey.loanOffering.prdOfferingName}&globalAccountNum=${BusinessKey.globalAccountNum}&accountId=${BusinessKey.accountId}&accountType=${BusinessKey.accountType.accountTypeId}
																	&recordOfficeId=${BusinessKey.office.officeId}&recordLoanOfficerId=${BusinessKey.personnel.personnelId}&randomNUm=${sessionScope.randomNUm}&currentFlowKey=${requestScope.currentFlowKey}">
												<mifos:mifoslabel name="loan.apply_payment" />
											</html-el:link><br> 
										</c:if>
									<c:if test="${BusinessKey.accountState.id!='7'}">
									 <html-el:link href="applyChargeAction.do?method=load&accountId=${BusinessKey.accountId}&randomNUm=${sessionScope.randomNUm}&currentFlowKey=${requestScope.currentFlowKey}">
										<mifos:mifoslabel name="loan.apply_charges" />
									</html-el:link></c:if><br>
									<c:choose>
										<c:when
											test="${(BusinessKey.accountState.id=='5' || BusinessKey.accountState.id=='9') }">
											<c:if test="${lastPaymentAction != '10'}">
												<html-el:link
													href="applyAdjustment.do?method=loadAdjustment&accountId=${BusinessKey.accountId}&globalAccountNum=${BusinessKey.globalAccountNum}&prdOfferingName=${BusinessKey.loanOffering.prdOfferingName}&randomNUm=${sessionScope.randomNUm}&currentFlowKey=${requestScope.currentFlowKey}">
													<mifos:mifoslabel name="loan.apply_adjustment" />
												</html-el:link>
											<br>
											</c:if>
										</c:when>
									</c:choose> </span>


								</c:when>
							</c:choose> <c:choose>
								<c:when
									test="${BusinessKey.accountState.id=='1' || BusinessKey.accountState.id=='2' || BusinessKey.accountState.id=='3' || BusinessKey.accountState.id=='4'}">

									<span class="fontnormal8pt"> 
									  <html-el:link href="applyChargeAction.do?method=load&accountId=${BusinessKey.accountId}&randomNUm=${sessionScope.randomNUm}&currentFlowKey=${requestScope.currentFlowKey}"> 
										<mifos:mifoslabel name="loan.apply_charges" />
									</html-el:link><br>
									</span>
								</c:when>
							</c:choose> 
							<c:choose>
								<c:when test="${BusinessKey.accountState.id==3 || BusinessKey.accountState.id==4}">
									<tr>
										<td class="paddingL10"><span class="fontnormal8pt">
											<html-el:link href="loanDisbursmentAction.do?method=load&accountId=${BusinessKey.accountId}&globalAccountNum=${BusinessKey.globalAccountNum}&prdOfferingName=${BusinessKey.loanOffering.prdOfferingName}&randomNUm=${sessionScope.randomNUm}&currentFlowKey=${requestScope.currentFlowKey}"> 
												<mifos:mifoslabel name="loan.disburseloan" />
											</html-el:link>
											<br></span>
										</td>
									</tr>
								</c:when>
							</c:choose> 
							<c:choose>
								<c:when
									test="${ BusinessKey.accountState.id=='9' || BusinessKey.accountState.id=='5'}">
									<span class="fontnormal8pt"> <html-el:link
										href="repayLoanAction.do?method=loadRepayment&accountId=${BusinessKey.accountId}&globalAccountNum=${BusinessKey.globalAccountNum}&prdOfferingName=${BusinessKey.loanOffering.prdOfferingName}&randomNUm=${sessionScope.randomNUm}&currentFlowKey=${requestScope.currentFlowKey}">
										<mifos:mifoslabel name="loan.repay" /><mifos:mifoslabel name="${ConfigurationConstants.LOAN}" />
									</html-el:link><br>
									</span>
								</c:when>
							</c:choose></td>
						<tr>
					</table>
					<table width="95%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td><img src="pages/framework/images/trans.gif" width="7"
								height="8"></td>
						</tr>
					</table>
					<table width="100%" border="0" cellpadding="2" cellspacing="0"
						class="bluetableborder">
						<tr>
							<td class="bluetablehead05"><span class="fontnormalbold"> <mifos:mifoslabel
								name="loan.performance_history" /> </span></td>
						</tr>
						<tr>
		                <td class="paddingL10"><span class="fontnormal8pt"><mifos:mifoslabel
								name="loan.of_payments" /> <c:out value="${BusinessKey.performanceHistory.noOfPayments}" /></span></td>
		              	</tr>
		             	 <tr>
		                <td class="paddingL10"><span class="fontnormal8pt"><mifos:mifoslabel
								name="loan.missed_payments" /> <c:out value="${BusinessKey.performanceHistory.totalNoOfMissedPayments}" /></span></td>
		              	</tr>
		              	<tr>
		                <td class="paddingL10"><span class="fontnormal8pt"><mifos:mifoslabel
								name="loan.days_arrears" /><c:out value="${BusinessKey.performanceHistory.daysInArrears}" /> </span></td>
		              	</tr>
		              	<tr>
		                <td class="paddingL10"><span class="fontnormal8pt"><mifos:mifoslabel
		                	name="loan.maturity_date" /><c:out value="${userdatefn:getUserLocaleDate(sessionScope.UserContext.preferredLocale,BusinessKey.performanceHistory.loanMaturityDate)}" />  </span></td>
		              	</tr>
					</table>
					<table width="95%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td><img src="pages/framework/images/trans.gif" width="7"
								height="8"></td>
						</tr>
					</table>
					<table width="100%" border="0" cellpadding="2" cellspacing="0"
						class="bluetableborder">
						<tr>
							<td class="bluetablehead05"><span class="fontnormalbold"> <mifos:mifoslabel
								name="loan.recent_notes" /> </span></td>
						</tr>
						<tr>
							<td class="paddingL10"><img
								src="pages/framework/images/trans.gif" width="10" height="2"></td>
						</tr>
						<tr>
							<td class="paddingL10">
							<c:choose>
	              				<c:when test="${!empty session:getFromSession(sessionScope.flowManager,requestScope.currentFlowKey,'notes')}">
									<c:forEach var="note" items="${session:getFromSession(sessionScope.flowManager,requestScope.currentFlowKey,'notes')}">
										<span class="fontnormal8ptbold"> <c:out value="${userdatefn:getUserLocaleDate(sessionScope.UserContext.preferredLocale,note.commentDate)}"/>:</span>
										<span class="fontnormal8pt"> 
				                				<c:out value="${note.comment}"/>-<em>
												<c:out value="${note.personnel.displayName}"/></em><br><br>
				                	     </span>
				                	</c:forEach>
				                </c:when>
	             				<c:otherwise>
		         					<span class="fontnormal"> 
		              	 				<mifos:mifoslabel name="accounts.NoNotesAvailable" />
		         					</span>
		     					</c:otherwise>
	 						</c:choose>
							</td>
						</tr>
						<tr>
							<td align="right" class="paddingleft05"><span
								class="fontnormal8pt"> <c:if test="${!empty session:getFromSession(sessionScope.flowManager,requestScope.currentFlowKey,'notes')}">
								<html-el:link href="notesAction.do?method=search&accountId=${BusinessKey.accountId}&globalAccountNum=${BusinessKey.globalAccountNum}&accountTypeId=${BusinessKey.accountType.accountTypeId}&currentFlowKey=${requestScope.currentFlowKey}&randomNUm=${sessionScope.randomNUm}">
									<mifos:mifoslabel name="loan.seeallnotes" />
								</html-el:link>
							</c:if> <br>
							<html-el:link href="notesAction.do?method=load&accountId=${BusinessKey.accountId}&currentFlowKey=${requestScope.currentFlowKey}&randomNUm=${sessionScope.randomNUm}">
								<mifos:mifoslabel name="loan.addnote" />
							</html-el:link> </span></td>
						</tr>
					</table>
					</td>
				</tr>
			</table>
			<!-- This hidden variable is being used in the next page -->
			<html-el:hidden property="accountTypeId" value="${BusinessKey.accountType.accountTypeId}" />
			<html-el:hidden property="accountId" value="${BusinessKey.accountId}" />
			<html-el:hidden property="globalAccountNum" value="${BusinessKey.globalAccountNum}"/>
	</html-el:form>
	</tiles:put>
</tiles:insert>