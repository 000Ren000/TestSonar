﻿
#Область СлужебныеПроцедурыИФункции

// Операция начала обмена
// проверяет, что нужный узел добавлен в план и правильно инициализирован.
//
// Параметры:
//  MobileApplicationVersion - строка- номер версии мобильного приложения;
//  MobileDeviceID - строка - не изменяемый код мобильного приложения, используется как код узла плана обмена.
//
// Возвращаемое значение:
//  ОбъектXDTO - содержит структуру ответа:
//  ResultMessage - строка - информационное сообщение;
//  Success - булево - флаг успешного завершения;
//  DeleteAppData - булево - флаг очистки данных на мобильном устройстве.
//
Функция StartExchange(MobileApplicationVersion, MobileDeviceID)
	
	Возврат МобильноеПриложениеЗаказыКлиентов.НачалоОбмена(MobileApplicationVersion, MobileDeviceID);
	
КонецФункции

// Операция получения настроек
// информационной базы для передачи в мобильное приложение.
//
// Параметры:
//  MobileDeviceID - строка - не изменяемый код мобильного приложения, используется как код узла плана обмена.
//
// Возвращаемое значение:
//  ОбъектXDTO - содержит структуру ответа:
//  ResultMessage - строка - информационное сообщение;
//  Success - булево - флаг успешного завершения;
//  AddChangeCustomer - булево - флаг возможности добавления изменения клиентов;
//  AddChangeCustomerOrders - булево - флаг возможности добавления изменения заказов клиентов;
//  UsingCustomerAgreement - число - использование соглашений с клиентами:
//    0 - типовые и индивидуальные соглашения,
//    1 - только типовые соглашения,
//    2 - только индивидуальные соглашения,
//    3 - соглашения не используются;
//  UsePricesInOrderLine - булево - флаг использования видов цен в строках заказа клиента(всегда истина для УТ/УП);
//  UseCustomerContract - булево - флаг использования договоров с клиентами;
//  UseGoodsBalance - булево - флаг использования информации об остатках товаров (всегда истина для УТ/УП);
//  PartnersHowContractors - булево - флаг использования партнеров как контрагентов;
//  UseCommission - булево - флаг использования комиссии;
//  UseManualDiscounts - булево - флаг использования ручных скидок;
//  UseStoreInOrderLine - булево - флаг использования складов в строках заказа клиента;
//  UseOrderStatus - булево - флаг использования статусов заказов клиентов;
//  ChangePriceInOrder - булево - флаг редактирования цен в заказе;
//  FrequencyExchangeRates - число - периодичность запроса цен номенклатуры (в часах);
//  FrequencyExchangeBalance - число - периодичность запроса остатков номенклатуры (в часах).
//
Функция GetSettings(MobileDeviceID)
	
	Возврат МобильноеПриложениеЗаказыКлиентов.ВыгрузитьНастройки(MobileDeviceID);
	
КонецФункции

// Операция получения заданий торговому представителю
// информационной базы для передачи в мобильное приложение.
//
// Параметры:
//  MobileDeviceID - строка - не изменяемый код мобильного приложения, используется как код узла плана обмена;
//
// Возвращаемое значение:
//  ОбъектXDTO - содержит структуру ответа:
//  ResultMessage - строка - информационное сообщение;
//  Success - булево - флаг успешного завершения.
//
Функция GetJobTargets(MobileDeviceID)
	
	Возврат МобильноеПриложениеЗаказыКлиентов.ВыгрузитьЗадания(MobileDeviceID);
	
КонецФункции

// Операция получения справочников "Валюты", "Виды цен", "Организации", "Склады"
// информационной базы для передачи в мобильное приложение.
//
// Параметры:
//  MobileDeviceID - строка - не изменяемый код мобильного приложения, используется как код узла плана обмена;
//
// Возвращаемое значение:
//  ОбъектXDTO - содержит структуру ответа:
//  ResultMessage - строка - информационное сообщение;
//  Success - булево - флаг успешного завершения.
//
Функция GetCatalogs(MobileDeviceID)
	
	Возврат МобильноеПриложениеЗаказыКлиентов.ВыгрузитьСправочники(MobileDeviceID);
	
КонецФункции

// Операция получения цен номенклатуры, а также сопутствующих справочников
// информационной базы для передачи в мобильное приложение.
//
// Параметры:
//  MobileDeviceID - строка - не изменяемый код мобильного приложения, используется как код узла плана обмена;
//  AllPrices - булево - "Истина" - выгрузка всех цен, "Ложь" - выгрузка только измененных;
//  Address - строка - адрес(имя временного файла) подготовленных данных для обмена.
//
// Возвращаемое значение:
//  ОбъектXDTO - содержит структуру ответа:
//  ResultMessage - строка - информационное сообщение;
//  Success - булево - флаг успешного завершения.
//
Функция GetPriceList(MobileDeviceID, AllPrices = Ложь, Address = "")
	
	Возврат МобильноеПриложениеЗаказыКлиентов.ВыгрузитьПрайсЛист(MobileDeviceID, AllPrices, Address);
	
КонецФункции

// Операция получения остатков номенклатуры, а также сопутствующих справочников
// информационной базы для передачи в мобильное приложение.
//
// Параметры:
//  MobileDeviceID - строка - не изменяемый код мобильного приложения, используется как код узла плана обмена;
//  Address - строка - адрес(имя временного файла) подготовленных данных для обмена.
//
// Возвращаемое значение:
//  ОбъектXDTO - содержит структуру ответа:
//  ResultMessage - строка - информационное сообщение;
//  Success - булево - флаг успешного завершения.
//
Функция GetOddments(MobileDeviceID, Address = "")
	
	Возврат МобильноеПриложениеЗаказыКлиентов.ВыгрузитьОстатки(MobileDeviceID, Address);
	
КонецФункции

// Операция получения информации по партнерам, а также сопутствующих справочников
// информационной базы для передачи в мобильное приложение.
//
// Параметры:
//  MobileDeviceID - строка - не изменяемый код мобильного приложения, используется как код узла плана обмена;
//  AllCustomers - булево - "Истина" - выгрузка информации по всем партнерам, "Ложь" - выгрузка только по измененным;
//  Customer - строка - выгрузка информации по конкретному партнеру;
//  Address - строка - адрес(имя временного файла) подготовленных данных для обмена.
//
// Возвращаемое значение:
//  ОбъектXDTO - содержит структуру ответа:
//  ResultMessage - строка - информационное сообщение;
//  Success - булево - флаг успешного завершения.
//
Функция GetCustomers(MobileDeviceID, AllCustomers = Ложь, Customer = "", Address = "")
	
	Возврат МобильноеПриложениеЗаказыКлиентов.ВыгрузитьКлиентов(MobileDeviceID, AllCustomers, Customer, Address);
	
КонецФункции

// Операция получения информации по статусам заказов клиентов.
//
// Параметры:
//  MobileDeviceID - строка - не изменяемый код мобильного приложения, используется как код узла плана обмена;
//  MessageExchange - ОбъектXDTO - содержит структуру запроса по статусам заказов.
//
// Возвращаемое значение:
//  ОбъектXDTO - содержит структуру ответа:
//  ResultMessage - строка - информационное сообщение;
//  Success - булево - флаг успешного завершения.
//
Функция GetStatusCustomersOrders(MobileDeviceID, MessageExchange)
	
	Возврат МобильноеПриложениеЗаказыКлиентов.ВыгрузитьСтатусыДокументов(MobileDeviceID, MessageExchange, 0);
	
КонецФункции

// Операция получения информации по статусам заявок на возврат клиентов.
//
// Параметры:
//  MobileDeviceID - строка - не изменяемый код мобильного приложения, используется как код узла плана обмена;
//  MessageExchange - ОбъектXDTO - содержит структуру запроса по статусам заказов.
//
// Возвращаемое значение:
//  ОбъектXDTO - содержит структуру ответа:
//  ResultMessage - строка - информационное сообщение;
//  Success - булево - флаг успешного завершения.
//
Функция GetDocumentsStatus(MobileDeviceID, MessageExchange, TypeOfDocs)
	
	Возврат МобильноеПриложениеЗаказыКлиентов.ВыгрузитьСтатусыДокументов(MobileDeviceID, MessageExchange, TypeOfDocs);
	
КонецФункции

// Операция записи заказов клиентов, созданных на мобильном устройстве.
//
// Параметры:
//  MobileDeviceID - строка - не изменяемый код мобильного приложения, используется как код узла плана обмена;
//  MessageExchange - ОбъектXDTO - содержит информацию по заказам клиентов.
//
// Возвращаемое значение:
//  ОбъектXDTO - содержит структуру ответа:
//  ResultMessage - строка - информационное сообщение;
//  Success - булево - флаг успешного завершения.
//
Функция FillCustomersOrders(MobileDeviceID, MessageExchange)
	
	Возврат МобильноеПриложениеЗаказыКлиентов.ЗагрузитьЗаказыКлиентов(MobileDeviceID, MessageExchange);
	
КонецФункции

// Операция записи заказов клиентов, созданных на мобильном устройстве.
//
// Параметры:
//  MobileDeviceID - строка - не изменяемый код мобильного приложения, используется как код узла плана обмена;
//  MessageExchange - ОбъектXDTO - содержит информацию по заказам клиентов.
//
// Возвращаемое значение:
//  ОбъектXDTO - содержит структуру ответа:
//  ResultMessage - строка - информационное сообщение;
//  Success - булево - флаг успешного завершения.
//
Функция FillRequestsToReturn(MobileDeviceID, MessageExchange)
	
	Возврат МобильноеПриложениеЗаказыКлиентов.ЗагрузитьЗаявкиНаВозвратТоваровОтКлиента(MobileDeviceID, MessageExchange);
	
КонецФункции

// Операция записи заданий торговым представителям, созданных на мобильном устройстве.
//
// Параметры:
//  MobileDeviceID - строка - не изменяемый код мобильного приложения, используется как код узла плана обмена;
//  MessageExchange - ОбъектXDTO - содержит информацию по заданиям клиентов.
//
// Возвращаемое значение:
//  ОбъектXDTO - содержит структуру ответа:
//  ResultMessage - строка - информационное сообщение;
//  Success - булево - флаг успешного завершения.
//
Функция FillJobTargets(MobileDeviceID, MessageExchange, JobTargetSettings)
	
	Возврат МобильноеПриложениеЗаказыКлиентов.ЗагрузитьЗаданияТорговымПредставителям(MobileDeviceID, MessageExchange, JobTargetSettings);
	
КонецФункции

// Операция записи справочников, созданных на мобильном устройстве.
//
// Параметры:
//  MobileDeviceID - строка - не изменяемый код мобильного приложения, используется как код узла плана обмена;
//  MessageExchange - ОбъектXDTO - содержит информацию по справочникам для записи.
//
// Возвращаемое значение:
//  ОбъектXDTO - содержит структуру ответа:
//  ResultMessage - строка - информационное сообщение;
//  Success - булево - флаг успешного завершения.
//
Функция FillCatalogs(MobileDeviceID, MessageExchange)
	
	Возврат МобильноеПриложениеЗаказыКлиентов.ЗагрузитьСправочники(MobileDeviceID, MessageExchange);
	
КонецФункции

// Операция записи заказов клиентов, созданных на мобильном устройстве.
//
// Параметры:
//  MobileDeviceID - строка - не изменяемый код мобильного приложения, используется как код узла плана обмена;
//  MessageExchange - ОбъектXDTO - содержит информацию по заказам клиентов.
//
// Возвращаемое значение:
//  ОбъектXDTO - содержит структуру ответа:
//  ResultMessage - строка - информационное сообщение;
//  Success - булево - флаг успешного завершения.
//
Функция FillCustomersPayments(MobileDeviceID, MessageExchange)
	
	Возврат МобильноеПриложениеЗаказыКлиентов.ЗагрузитьОплатыКлиентов(MobileDeviceID, MessageExchange);
	
КонецФункции

// Операция записи идентификатора получателя push-уведомлений, сформированного на мобильном устройстве.
//
// Параметры:
//  MobileDeviceID - строка - не изменяемый код мобильного приложения, используется как код узла плана обмена;
//  PushNotificationsSubscriberID - ХранилищеЗначения - идентификатор получателя push-уведомлений.
//
// Возвращаемое значение:
//  ОбъектXDTO - содержит структуру ответа:
//  ResultMessage - строка - информационное сообщение;
//  Success - булево - флаг успешного завершения.
//
Функция FillPushNotificationsSubscriberID(MobileDeviceID, PushNotificationsSubscriberID)
	
	Возврат МобильноеПриложениеЗаказыКлиентов.ЗаписьИдентификатораПодписчикаДоставляемыхУведомлений(MobileDeviceID,
		PushNotificationsSubscriberID);
КонецФункции

#КонецОбласти