﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Подсистема "ИнтернетПоддержкаПользователей.СистемаБыстрыхПлатежей.БазоваяФункциональностьСБП".
// ОбщийМодуль.СервисСистемаБыстрыхПлатежей.
//
// Серверные процедуры обмена данными с Системой быстрых платежей:
//  - предоставление учетных данных мерчанта;
//  - загрузка и обработка настроек.
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

#Область ВызовОперацийАутентификации

////////////////////////////////////////////////////////////////////////////////
// Вызов операции POST /sbp/v1/members/{memberId}/auth/get-credentials-grant.

// Получает обновленный токен для схемы аутентификации Resource owner password
// credentials grant (https://tools.ietf.org/html/rfc6749#section-4.3).
//
// Параметры:
//  Логин - Строка - логин пользователя;
//  Пароль - Строка - пароль пользователя;
//  ИдентификаторУчастника - Строка - идентификатор участника СБП.
//
// Возвращаемое значение:
//  Структура - получения данных аутентификации:
//    *Токен - Строка - идентификатор, по которому выполняется оплата;
//    *ТипТокена - Строка - идентификатор оплаты в СБП;
//    *ИстеченияСрока - Дата - идентификатор оплаты в СБП;
//    *КодОшибки - Строка - строковый код возникшей ошибки, который
//     может быть обработан вызывающим методом;
//    *СообщениеОбОшибке  - Строка, ФорматированнаяСтрока - сообщение об ошибке для пользователя;
//    *ИнформацияОбОшибке - Строка, ФорматированнаяСтрока - сообщение об ошибке для администратора.
//
Функция ОперацияПредоставлениеУчетныхДанных(Логин, Пароль, ИдентификаторУчастника) Экспорт
	
	СистемаБыстрыхПлатежейСлужебный.ЗаписатьИнформациюВЖурналРегистрации(
		НСтр("ru = 'Обновление токена Resource owner password credentials grant.'"),
		Ложь);
	
	РезультатОперации = СистемаБыстрыхПлатежейСлужебный.НовыйРезультатОперации();
	РезультатОперации.Вставить("Токен",              Неопределено);
	РезультатОперации.Вставить("ТипТокена",          Неопределено);
	РезультатОперации.Вставить("ИстеченияСрока", Неопределено);
	
	ПараметрыПодключения = СистемаБыстрыхПлатежейСлужебный.ИнициализироватьПараметрыПодключения();
	
	URLОперации = СистемаБыстрыхПлатежейСлужебный.URLОперацииСервиса(
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			"/members/%1/auth/get-credentials-grant",
			ИдентификаторУчастника));
	
	РезультатИПП = ДанныеАутентификации(URLОперации);
	
	Если РезультатИПП.Ошибка Тогда
		РезультатОперации.КодОшибки = СистемаБыстрыхПлатежейСлужебный.КодОшибкиНеверныйЛогинИлиПароль();
		РезультатОперации.СообщениеОбОшибке = РезультатИПП.ИнформацияОбОшибке;
		РезультатОперации.ИнформацияОбОшибке = РезультатИПП.ИнформацияОбОшибке;
		Возврат РезультатОперации;
	КонецЕсли;
	
	ПараметрыЗапросаJSON = get_credentials_grant(
		Логин,
		Пароль,
		РезультатИПП.ДанныеАутентификации);
	
	Заголовки = Новый Соответствие;
	Заголовки.Вставить("Content-Type", "application/json");
	Заголовки.Вставить("X-Correlation-ID", Строка(Новый УникальныйИдентификатор));
	
	ПараметрыОтправки = Новый Структура;
	ПараметрыОтправки.Вставить("Метод"                   , "POST");
	ПараметрыОтправки.Вставить("ФорматОтвета"            , 1);
	ПараметрыОтправки.Вставить("Заголовки"               , Заголовки);
	ПараметрыОтправки.Вставить("ДанныеДляОбработки"      , ПараметрыЗапросаJSON);
	ПараметрыОтправки.Вставить("ФорматДанныхДляОбработки", 1);
	ПараметрыОтправки.Вставить("НастройкиПрокси"         , ПараметрыПодключения.НастройкиПроксиСервера);
	ПараметрыОтправки.Вставить("Таймаут"                 , 30);
	
	// Вызов операции сервиса.
	РезультатОтправки = ИнтернетПоддержкаПользователей.ЗагрузитьСодержимоеИзИнтернет(
		URLОперации,
		,
		,
		ПараметрыОтправки);
	
	Если Не ПустаяСтрока(РезультатОтправки.КодОшибки) Тогда
		
		РезультатОперации.КодОшибки = СистемаБыстрыхПлатежейСлужебный.ПереопределитьКодОшибкиСервиса(
			РезультатОтправки.КодСостояния);
		
		// Для метода используется собственное переопределении ошибки
		// т.к. формат ошибок указанный в rfc 6749 отличается
		// от выбранного для других методов.
		РезультатОперации.СообщениеОбОшибке = ПереопределитьСообщениеПользователюPasswordCredentialsGrant(
			РезультатОперации.КодОшибки,
			РезультатОтправки.Содержимое);
		
		РезультатОперации.ИнформацияОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось обновить токен аутентификации.
				|
				|%1
				|
				|Техническая информация об ошибке:
				|При получении токена сервис вернул ошибку.
				|URL: %2
				|Код ошибки: %3
				|X-Correlation-ID: %4
				|Подробная информация:
				|%5'"),
			РезультатОперации.СообщениеОбОшибке,
			URLОперации,
			РезультатОтправки.КодОшибки,
			Заголовки.Получить("X-Correlation-ID"),
			РезультатОтправки.ИнформацияОбОшибке);
		
		СистемаБыстрыхПлатежейСлужебный.ЗаписатьИнформациюВЖурналРегистрации(
			Строка(РезультатОперации.ИнформацияОбОшибке),
			Истина);
		
		Возврат РезультатОперации;
		
	КонецЕсли;
	
	ДанныеАутентификации = ПрочитатьДанные_get_credentials_grant(
		РезультатОтправки.Содержимое);
	
	РезультатОперации.Токен              = ДанныеАутентификации.sbpMemberResponse.access_token;
	РезультатОперации.ИстеченияСрока = ДанныеАутентификации.sbpMemberResponse.expires_in;
	РезультатОперации.ТипТокена          = ДанныеАутентификации.sbpMemberResponse.token_type;
	
	СистемаБыстрыхПлатежейСлужебный.ЗаписатьИнформациюВЖурналРегистрации(
		НСтр("ru = 'Завершено обновление токена.'"),
		Ложь);
	
	Возврат РезультатОперации;
	
КонецФункции

// Формирует параметры запроса для операции
// /sbp/v1/members/{memberId}/auth/get-credentials-grant.
//
Функция get_credentials_grant(
		Логин,
		Пароль,
		ДанныеАутентификации)
	
	ЗаписьДанныхСообщения = Новый ЗаписьJSON;
	ЗаписьДанныхСообщения.УстановитьСтроку();
	ЗаписьДанныхСообщения.ЗаписатьНачалоОбъекта();
	
	// Данные аутентификации.
	СистемаБыстрыхПлатежейСлужебный.ЗаписатьДанныеАутентификации(
		ЗаписьДанныхСообщения,
		ДанныеАутентификации);
	
	// Параметры клиента.
	СистемаБыстрыхПлатежейСлужебный.ЗаписатьПараметрыКлиента(
		ЗаписьДанныхСообщения);
	
	ЗаписьДанныхСообщения.ЗаписатьИмяСвойства("password");
	ЗаписьДанныхСообщения.ЗаписатьЗначение(Пароль);
	
	ЗаписьДанныхСообщения.ЗаписатьИмяСвойства("username");
	ЗаписьДанныхСообщения.ЗаписатьЗначение(Логин);
	
	ЗаписьДанныхСообщения.ЗаписатьКонецОбъекта();
	
	Возврат ЗаписьДанныхСообщения.Закрыть();
	
КонецФункции

// Чтение ответа операции /sbp/v1/members/{memberId}/auth/get-credentials-grant.
//
Функция ПрочитатьДанные_get_credentials_grant(ТелоJSON)
	
	// Ответ сервиса:
	// {
	//  "accessToken": "string",
	//  "expiresIn": 0,
	//  "tokenType": "string"
	// }
	
	ЧтениеОтвета = Новый ЧтениеJSON;
	ЧтениеОтвета.УстановитьСтроку(ТелоJSON);
	Результат = ПрочитатьJSON(ЧтениеОтвета);
	
	Возврат Результат;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Вызов операции POST /sbp/v1/members/{memberId}/merchants/{merchantId}/get-merchant-info

// Производит проверку данных аутентификации в сервисе участника СБП.
//
// Параметры:
//  ПараметрыНастройкиПодключения - Структура - см. СистемаБыстрыхПлатежейСлужебный.ПараметрыНастройкиПодключения;
//  ПараметрыАутентификации - Структура - данные аутентификации.
//
// Возвращаемое значение:
//  Структура - результат проверки параметров авторизации:
//    *КодОшибки - Строка - строковый код возникшей ошибки, который
//     может быть обработан вызывающим методом;
//    *СообщениеОбОшибке - Строка, ФорматированнаяСтрока - сообщение об ошибке для пользователя;
//    *ИнформацияОбОшибке - Строка, ФорматированнаяСтрока - сообщение об ошибке для администратора.
//
Функция ОперацияПроверитьПараметрыПодключения(
		ПараметрыНастройкиПодключения,
		ПараметрыАутентификации) Экспорт
	
	РезультатОперации = СистемаБыстрыхПлатежейСлужебный.НовыйРезультатОперации();
	
	URLОперации = СистемаБыстрыхПлатежейСлужебный.URLОперацииСервиса(
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			"/members/%1/merchants/%2/get-merchant-info",
			ПараметрыНастройкиПодключения.ИдентификаторУчастника,
			ПараметрыНастройкиПодключения.ИдентификаторМерчанта));
	
	РезультатИПП = ДанныеАутентификации(URLОперации);
	
	Если РезультатИПП.Ошибка Тогда
		РезультатОперации.КодОшибки = СистемаБыстрыхПлатежейСлужебный.КодОшибкиНеверныйЛогинИлиПароль();
		РезультатОперации.СообщениеОбОшибке = РезультатИПП.ИнформацияОбОшибке;
		РезультатОперации.ИнформацияОбОшибке = РезультатИПП.ИнформацияОбОшибке;
		Возврат РезультатОперации;
	КонецЕсли;
	
	ДанныеДляПодписи = Новый Массив;
	Если СистемаБыстрыхПлатежейСлужебный.УчастникСБПИспользуетHMAC(ПараметрыНастройкиПодключения.ТипАутентификации) Тогда
		ДанныеДляПодписи.Добавить(ПараметрыНастройкиПодключения.ИдентификаторМерчанта);
	КонецЕсли;
	
	РезультатСБП = СистемаБыстрыхПлатежейСлужебный.ЗаголовокАвторизацииУчастникаСБП(
		ПараметрыНастройкиПодключения,
		ПараметрыАутентификации,
		ДанныеДляПодписи,
		ЗначениеЗаполнено(ПараметрыНастройкиПодключения.НастройкаПодключения));
	
	Если РезультатСБП.Ошибка Тогда
		РезультатОперации.КодОшибки = СистемаБыстрыхПлатежейСлужебный.КодОшибкиНеверныйЛогинИлиПароль();
		РезультатОперации.СообщениеОбОшибке = РезультатСБП.ИнформацияОбОшибке;
		РезультатОперации.ИнформацияОбОшибке = РезультатСБП.ИнформацияОбОшибке;
		Возврат РезультатОперации;
	КонецЕсли;

	ПараметрыПодключения = СистемаБыстрыхПлатежейСлужебный.ИнициализироватьПараметрыПодключения();
	
	ПараметрыЗапросаJSON = get_merchant_info(
		РезультатИПП.ДанныеАутентификации,
		РезультатСБП.Аутентификация,
		ПараметрыНастройкиПодключения.ИдентификаторМерчанта);
	
	Заголовки = Новый Соответствие;
	Заголовки.Вставить("Content-Type", "application/json");
	Заголовки.Вставить("X-Correlation-ID", Строка(Новый УникальныйИдентификатор));
	
	ПараметрыОтправки = Новый Структура;
	ПараметрыОтправки.Вставить("Метод"                   , "POST");
	ПараметрыОтправки.Вставить("ФорматОтвета"            , 1);
	ПараметрыОтправки.Вставить("Заголовки"               , Заголовки);
	ПараметрыОтправки.Вставить("ДанныеДляОбработки"      , ПараметрыЗапросаJSON);
	ПараметрыОтправки.Вставить("ФорматДанныхДляОбработки", 1);
	ПараметрыОтправки.Вставить("НастройкиПрокси"         , ПараметрыПодключения.НастройкиПроксиСервера);
	ПараметрыОтправки.Вставить("Таймаут"                 , 30);
	
	// Вызов операции сервиса.
	РезультатОтправки = ИнтернетПоддержкаПользователей.ЗагрузитьСодержимоеИзИнтернет(
		URLОперации,
		,
		,
		ПараметрыОтправки);
	
	Если Не ПустаяСтрока(РезультатОтправки.КодОшибки) Тогда
		
		РезультатОперации.КодОшибки = СистемаБыстрыхПлатежейСлужебный.ПереопределитьКодОшибкиСервиса(
			РезультатОтправки.КодСостояния);
		РезультатОперации.СообщениеОбОшибке = СистемаБыстрыхПлатежейСлужебный.ПереопределитьСообщениеПользователю(
			РезультатОперации.КодОшибки,
			РезультатОтправки.Содержимое);
		
		РезультатОперации.ИнформацияОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось проверить данные аутентификации в банке.
				|
				|%1
				|
				|Техническая информация об ошибке:
				|При проверке данных аутентификации сервис вернул ошибку.
				|URL: %2
				|Код ошибки: %3
				|Подробная информация:
				|%4'"),
			РезультатОперации.СообщениеОбОшибке,
			URLОперации,
			РезультатОтправки.КодОшибки,
			РезультатОтправки.ИнформацияОбОшибке);
		
		СистемаБыстрыхПлатежейСлужебный.ЗаписатьИнформациюВЖурналРегистрации(
			Строка(РезультатОперации.ИнформацияОбОшибке),
			Истина);
		
		Возврат РезультатОперации;
		
	КонецЕсли;
	
	ИдентификаторМерчатанаОтвет = ПрочитатьДанные_get_merchant_info(
		РезультатОтправки.Содержимое);
	
	Если ИдентификаторМерчатанаОтвет <> ПараметрыНастройкиПодключения.ИдентификаторМерчанта Тогда
		РезультатОперации.КодОшибки = СистемаБыстрыхПлатежейСлужебный.КодОшибкиНеизвестнаяОшибка();
		РезультатОперации.СообщениеОбОшибке = НСтр("ru = 'Идентификатор торговой точки отличается от исходного.'");
		РезультатОперации.ИнформацияОбОшибке = НСтр("ru = 'Идентификатор торговой точки отличается от исходного.'");
		СистемаБыстрыхПлатежейСлужебный.ЗаписатьИнформациюВЖурналРегистрации(
			Строка(РезультатОперации.ИнформацияОбОшибке),
			Истина);
	КонецЕсли;
	
	Возврат РезультатОперации;
	
КонецФункции

// Формирует параметры запроса для операции
// /sbp/v1/members/{memberId}/merchants/{merchantId}/get-merchant-info.
//
Функция get_merchant_info(
		ДанныеАутентификации,
		ЗаголовокАутентификации,
		ИдентификаторУчастника)
	
	ЗаписьДанныхСообщения = Новый ЗаписьJSON;
	ЗаписьДанныхСообщения.УстановитьСтроку();
	ЗаписьДанныхСообщения.ЗаписатьНачалоОбъекта();
	
	// Данные аутентификации.
	СистемаБыстрыхПлатежейСлужебный.ЗаписатьДанныеАутентификации(
		ЗаписьДанныхСообщения,
		ДанныеАутентификации);
	
	// Данные аутентификации участника СБП.
	СистемаБыстрыхПлатежейСлужебный.ЗаписатьДанныеАутентификацииУчастникаСБП(
		ЗаписьДанныхСообщения,
		ЗаголовокАутентификации,
		ИдентификаторУчастника);
	
	// Параметры клиента.
	СистемаБыстрыхПлатежейСлужебный.ЗаписатьПараметрыКлиента(
		ЗаписьДанныхСообщения);
	
	ЗаписьДанныхСообщения.ЗаписатьКонецОбъекта();
	
	Возврат ЗаписьДанныхСообщения.Закрыть();
	
КонецФункции

// Чтение ответа операции:
// /sbp/v1/members/{memberId}/merchants/{merchantId}/get-merchant-info.
//
Функция ПрочитатьДанные_get_merchant_info(ТелоJSON)
	
	// Ответ сервиса:
	//  merchantId - идентификатор мерчанта;
	// 
	// {
	//   "merchantId": "string"
	// }
	
	ТекстЖурналРегистрации = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Получен ответ СБП:
			|%1'"),
		ТелоJSON);
	
	СистемаБыстрыхПлатежейСлужебный.ЗаписатьИнформациюВЖурналРегистрации(
		ТекстЖурналРегистрации,
		Ложь);
	
	ЧтениеОтвета = Новый ЧтениеJSON;
	ЧтениеОтвета.УстановитьСтроку(ТелоJSON);
	Результат = ПрочитатьJSON(ЧтениеОтвета);
	
	Возврат Результат.sbpMemberResponse.merchantId;
	
КонецФункции

#КонецОбласти

#Область ВызовОперацийПолучениеНастроекУчастников

////////////////////////////////////////////////////////////////////////////////
// Вызов операции GET /sbp/v1/members/infos

// Получает идентификаторы участников СБП из сервиса.
//
// Возвращаемое значение:
//  Массив из Структура - загруженные настройки.
//
Функция ОперацияНастройкиУчастниковСБП() Экспорт
	
	СистемаБыстрыхПлатежейСлужебный.ЗаписатьИнформациюВЖурналРегистрации(
		НСтр("ru = 'Загрузка идентификаторов платежных систем СБП.'"),
		Ложь);
	
	РезультатОперации = СистемаБыстрыхПлатежейСлужебный.НовыйРезультатОперации();
	РезультатОперации.Вставить("Настройки", Неопределено);
	URLОперации = СистемаБыстрыхПлатежейСлужебный.URLОперацииСервиса(
		"/members/infos");
	
	ПараметрыПодключения = СистемаБыстрыхПлатежейСлужебный.ИнициализироватьПараметрыПодключения();
	
	ПараметрыОтправки = Новый Структура;
	ПараметрыОтправки.Вставить("Метод"                   , "GET");
	ПараметрыОтправки.Вставить("ФорматОтвета"            , 1);
	ПараметрыОтправки.Вставить("ФорматДанныхДляОбработки", 1);
	ПараметрыОтправки.Вставить("НастройкиПрокси"         , ПараметрыПодключения.НастройкиПроксиСервера);
	ПараметрыОтправки.Вставить("Таймаут"                 , 30);
	
	// Вызов операции сервиса.
	РезультатОтправки = ИнтернетПоддержкаПользователей.ЗагрузитьСодержимоеИзИнтернет(
		URLОперации,
		,
		,
		ПараметрыОтправки);
	
	Если Не ПустаяСтрока(РезультатОтправки.КодОшибки) Тогда
		
		ИнформацияОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось получить информацию об идентификаторах участников СБП.
				|
				|Техническая информация об ошибке:
				|При получении информации об идентификаторах платежных систем СБП возникли ошибки.
				|URL: %1
				|Код ошибки: %2
				|Подробная информация:
				|%3'"),
			URLОперации,
			РезультатОтправки.КодОшибки,
			РезультатОтправки.ИнформацияОбОшибке);
		
		СистемаБыстрыхПлатежейСлужебный.ЗаписатьИнформациюВЖурналРегистрации(
			Строка(ИнформацияОбОшибке),
			Истина);
		
		РезультатОперации.КодОшибки = СистемаБыстрыхПлатежейСлужебный.КодОшибкиНеизвестнаяОшибка();
		РезультатОперации.СообщениеОбОшибке = НСтр("ru = 'Не удалось загрузить список участников СБП.'");
		РезультатОперации.ИнформацияОбОшибке = ИнформацияОбОшибке;
		
		Возврат РезультатОперации;
		
	КонецЕсли;
	
	РезультатОперации.Настройки = ПрочитатьДанные_sbp_members(РезультатОтправки.Содержимое);
	
	СистемаБыстрыхПлатежейСлужебный.ЗаписатьИнформациюВЖурналРегистрации(
		НСтр("ru = 'Завершена загрузка идентификаторов платежных систем СБП.'"),
		Ложь);
	
	Возврат РезультатОперации;
	
КонецФункции

// Чтение ответа операции:
// /attachments/sbp/sbp-members.json.
//
Функция ПрочитатьДанные_sbp_members(ТелоJSON)
	
	// Ответ сервиса:
	// [
	//  {
	//    "memberId": "string",
	//    "memberName": "string",
	//    "biks": [
	//      "string"
	//    ],
	//    "integrationEnabled": true,
	//    "personalAccountPageUrl": "string",
	//    "attentionText": "string",
	//    "c2bSupported": true,
	//    "c2bVerified": true,
	//    "c2bIntegrationSupported": true,
	//    "c2bCashRegisterPaymentSupported": true,
	//    "authorizationType": "RESOURCE_OWNER_PASSWORD_CREDENTIALS_GRANT",
	//    "inn": "string",
	//    "reconciliationOfSettlementsSupported": true,
	//    "paymentAggregator": true
	//  }
	// ]
	
	ЧтениеОтвета = Новый ЧтениеJSON;
	ЧтениеОтвета.УстановитьСтроку(ТелоJSON);
	Результат = ПрочитатьJSON(ЧтениеОтвета);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область Аутентификация

// Возвращает логин и пароль Интернет-поддержки или тикет аутентификации.
//
// Параметры:
//  URLОперации -Строка - URL операции, для которой получаются данные аутентификации.
//
// Возвращаемое значение:
//  Структура - структура, содержащая результаты определения параметров
//    аутентификации пользователя Интернет-поддержки:
//    *ДанныеАутентификации - Структура - параметры аутентификации пользователя Интернет-поддержки;
//    *ИнформацияОбОшибке   - Строка    - информация об ошибке для пользователя.
//    *Ошибка               - Строка    - признак наличия ошибки.
//
Функция ДанныеАутентификации(URLОперации)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Результат = Новый Структура;
	Результат.Вставить("ДанныеАутентификации", Новый Структура);
	Результат.Вставить("ИнформацияОбОшибке",   "");
	Результат.Вставить("Ошибка",               Ложь);
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		
		МодульИнтернетПоддержкаПользователейВМоделиСервиса =
			ОбщегоНазначения.ОбщийМодуль("ИнтернетПоддержкаПользователейВМоделиСервиса");
		РезультатПолученияТикета =
			МодульИнтернетПоддержкаПользователейВМоделиСервиса.ТикетАутентификацииНаПорталеПоддержки(
				URLОперации);
		
		Если ПустаяСтрока(РезультатПолученияТикета.КодОшибки) Тогда
			Результат.ДанныеАутентификации.Вставить("Тикет", РезультатПолученияТикета.Тикет);
		Иначе
			Результат.Ошибка = Истина;
			Результат.ИнформацияОбОшибке =
				НСтр("ru = 'Ошибка аутентификации в сервисе.
					|Подробнее см. в журнале регистрации.'");
			ПодробнаяИнформацияОбОшибке =
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Не удалось вызвать операцию %1.
						|Не удалось выполнить аутентификацию.
						|%2'"),
					URLОперации,
					РезультатПолученияТикета.ИнформацияОбОшибке);
			СистемаБыстрыхПлатежейСлужебный.ЗаписатьИнформациюВЖурналРегистрации(
				ПодробнаяИнформацияОбОшибке,
				Истина);
		КонецЕсли;
	Иначе
		
		Результат.ДанныеАутентификации = ИнтернетПоддержкаПользователей.ДанныеАутентификацииПользователяИнтернетПоддержки();
		Если Результат.ДанныеАутентификации = Неопределено Тогда
			Результат.Ошибка             = Истина;
			Результат.ИнформацияОбОшибке =
				НСтр("ru = 'Для работы с сервисом необходимо подключить Интернет-поддержку пользователей.'");
			СистемаБыстрыхПлатежейСлужебный.ЗаписатьИнформациюВЖурналРегистрации(
				Результат.ИнформацияОбОшибке);
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область ResourceOwnerPasswordCredentialsGrant

// Определяет по коду ошибки сообщение пользователю.
//
// Параметры:
//  КодОшибки - Строка - ошибка сервиса см. функцию
//    СистемаБыстрыхПлатежейСлужебный.ПереопределитьКодОшибкиСервиса.
//  ТелоJSON  - Строка - содержимое ответа сервиса.
//
// Возвращаемое значение:
//  Строка - сообщение пользователю.
//
Функция ПереопределитьСообщениеПользователюPasswordCredentialsGrant(
		КодОшибки,
		ТелоJSON = "")
	
	КодОшибкиСервиса = "";
	
	// Определение ошибки выполняется через попытку, т.к. в случае ошибки сервиса
	// есть вероятность получить не формализованное сообщение.
	Попытка
		ЧтениеОтвета = Новый ЧтениеJSON;
		ЧтениеОтвета.УстановитьСтроку(ТелоJSON);
		Результат = ПрочитатьJSON(ЧтениеОтвета);
		КодОшибкиСервиса = ВРег(Результат.error);
	Исключение
		КодОшибкиСервиса = "";
	КонецПопытки;
	
	Если КодОшибкиСервиса = "BAD_REQUEST_1C" Тогда
		Возврат НСтр("ru = 'Неверный набор параметров или формат запроса к сервису Портала 1С:ИТС.'");
	ИначеЕсли КодОшибкиСервиса = "USER_AUTHENTICATION_EXCEPTION_1C" Тогда
		Возврат НСтр("ru = 'Ошибка аутентификации на Портале 1С:ИТС.'");
	ИначеЕсли КодОшибкиСервиса = "INVALID_REQUEST"
		Или КодОшибкиСервиса = "INVALID_CLIENT"
		Или КодОшибкиСервиса = "INVALID_GRANT"
		Или КодОшибкиСервиса = "UNAUTHORIZED_CLIENT"
		Или КодОшибкиСервиса = "UNSUPPORTED_GRANT_TYPE" Тогда
		Возврат НСтр("ru = 'Ошибка аутентификации в сервисе банка.'");
	КонецЕсли;
	
	Возврат НСтр("ru = 'Неизвестная ошибка при подключении к сервису.'");
	
КонецФункции

#КонецОбласти

#КонецОбласти 
