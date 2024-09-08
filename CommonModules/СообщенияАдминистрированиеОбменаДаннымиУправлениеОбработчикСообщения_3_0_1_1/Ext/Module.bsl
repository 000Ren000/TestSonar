﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Пространство имен версии интерфейса сообщений.
//
// Возвращаемое значение:
//   Строка - пространство имен.
//
Функция Пакет() Экспорт
	
	Возврат "http://www.1c.ru/SaaS/ExchangeAdministration/Manage/" + Версия();
	
КонецФункции

// Версия интерфейса сообщений, обслуживаемая обработчиком.
//
// Возвращаемое значение:
//   Строка - версия интерфейса сообщений.
//
Функция Версия() Экспорт
	
	Возврат "3.0.1.1";
	
КонецФункции

// Базовый тип для сообщений версии.
//
// Возвращаемое значение:
//   ТипОбъектаXDTO - базовый тип тела сообщения.
//
Функция БазовыйТип() Экспорт
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("ТехнологияСервиса") Тогда
		ВызватьИсключение НСтр("ru = 'Отсутствует менеджер сервиса.'");
	КонецЕсли;
	
	МодульСообщенияВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("СообщенияВМоделиСервиса");
	
	Возврат МодульСообщенияВМоделиСервиса.ТипТело();
	
КонецФункции

// Выполняет обработку входящих сообщений модели сервиса
//
// Параметры:
//   Сообщение   - ОбъектXDTO - входящее сообщение.
//   Отправитель - ПланОбменаСсылка.ОбменСообщениями - узел плана обмена, соответствующий отправителю сообщения.
//   СообщениеОбработано - Булево - флаг успешной обработки сообщения. Значение данного параметра необходимо
//                         установить равным Истина в том случае, если сообщение было успешно прочитано в данном обработчике.
//
Процедура ОбработатьСообщениеМоделиСервиса(Знач Сообщение, Знач Отправитель, СообщениеОбработано) Экспорт
	
	СообщениеОбработано = Истина;
	
	Словарь = СообщенияАдминистрированиеОбменаДаннымиУправлениеИнтерфейс;
	ТипСообщения = Сообщение.Body.Тип();
	
	Если ТипСообщения = Словарь.СообщениеПодключитьКорреспондента(Пакет()) Тогда
		ПодключитьКорреспондента(Сообщение, Отправитель);
	ИначеЕсли ТипСообщения = Словарь.СообщениеУстановитьНастройкиТранспорта(Пакет()) Тогда
		УстановитьНастройкиТранспорта(Сообщение, Отправитель);
	ИначеЕсли ТипСообщения = Словарь.СообщениеУдалитьНастройкуСинхронизации(Пакет()) Тогда
		УдалитьНастройкуСинхронизации(Сообщение, Отправитель);
	ИначеЕсли ТипСообщения = Словарь.СообщениеВыполнитьСинхронизацию(Пакет()) Тогда
		ВыполнитьСинхронизацию(Сообщение, Отправитель);
	Иначе
		СообщениеОбработано = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПодключитьКорреспондента(Сообщение, Отправитель)
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("ТехнологияСервиса") Тогда
		Возврат;
	КонецЕсли;
	
	ИмяПланаОбменаСообщениями     = "ОбменСообщениями";
	МодульОбменСообщениями        = ОбщегоНазначения.ОбщийМодуль("ОбменСообщениями");
	МодульСообщенияВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("СообщенияВМоделиСервиса");
	МенеджерПланаОбменСообщениями = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени("ПланОбмена."
		+ ИмяПланаОбменаСообщениями);
	
	ЭтотУзелОбменаСообщениями = МенеджерПланаОбменСообщениями.ЭтотУзел();
	
	Тело = Сообщение.Body;
	
	// Проверяем эту конечную точку.
	ЭтаКонечнаяТочка = ОбменДаннымиВМоделиСервиса.МенеджерПланаОбменаКонечныхТочек().НайтиПоКоду(Тело.SenderId);
	
	Если ЭтаКонечнаяТочка.Пустая()
		ИЛИ ЭтаКонечнаяТочка <> ЭтотУзелОбменаСообщениями Тогда
		
		// Отправляем сообщение в менеджер сервиса об ошибке.
		ПредставлениеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Конечная точка не соответствует ожидаемой. Код ожидаемой конечной точки %1. Код текущей конечной точки %2.'"),
			Тело.SenderId,
			ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЭтотУзелОбменаСообщениями, "Код"));
			
		ОтправитьОтветноеСообщениеОбОшибкеПодключения(Сообщение, Отправитель, ПредставлениеОшибки);	
		Возврат;
		
	КонецЕсли;
	
	// Проверяем то, что корреспондент уже был подключен ранее.
	Корреспондент = ОбменДаннымиВМоделиСервиса.МенеджерПланаОбменаКонечныхТочек().НайтиПоКоду(Тело.RecipientId);
	
	Если Корреспондент.Пустая() Тогда // Подключаем конечную точку корреспондента.
		
		Отказ = Ложь;
		ПодключенныйКорреспондент = Неопределено;
		
		НастройкиПодключенияОтправителя = ОбменДаннымиСервер.СтруктураПараметровWS();
		НастройкиПодключенияОтправителя.WSURLВебСервиса = Тело.RecipientURL;
		НастройкиПодключенияОтправителя.WSИмяПользователя = Тело.RecipientUser;
		НастройкиПодключенияОтправителя.WSПароль = Тело.RecipientPassword;
		
		НастройкиПодключенияПолучателя = ОбменДаннымиСервер.СтруктураПараметровWS();
		НастройкиПодключенияПолучателя.WSURLВебСервиса = Тело.SenderURL;
		НастройкиПодключенияПолучателя.WSИмяПользователя = Тело.SenderUser;
		НастройкиПодключенияПолучателя.WSПароль = Тело.SenderPassword;
		
		МодульОбменСообщениями.ПодключитьКонечнуюТочку(
									Отказ,
									НастройкиПодключенияОтправителя,
									НастройкиПодключенияПолучателя,
									ПодключенныйКорреспондент,
									Тело.RecipientName,
									Тело.SenderName);
		
		Если Отказ Тогда // Отправляем сообщение в менеджер сервиса об ошибке.
			
			ПредставлениеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Ошибка подключения конечной точки корреспондента обмена. Код конечной точки корреспондента обмена %1.'"),
				Тело.RecipientId);
				
			ОтправитьОтветноеСообщениеОбОшибкеПодключения(Сообщение, Отправитель, ПредставлениеОшибки);	
			Возврат;
			
		КонецЕсли;
		
		ПодключенныйКорреспондентКод = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПодключенныйКорреспондент, "Код");
		
		Если ПодключенныйКорреспондентКод <> Тело.RecipientId Тогда
			
			// Подключили не того корреспондента обмена.
			// Отправляем сообщение в менеджер сервиса об ошибке.
			ПредставлениеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Ошибка при подключении конечной точки корреспондента обмена.
				|Настройки подключения веб-сервиса не соответствуют ожидаемым.
				|Код ожидаемой конечной точки корреспондента обмена %1.
				|Код подключенной конечной точки корреспондента обмена %2.'"),
				Тело.RecipientId,
				ПодключенныйКорреспондентКод);
			
			ОтправитьОтветноеСообщениеОбОшибкеПодключения(Сообщение, Отправитель, ПредставлениеОшибки);	
			Возврат;
			
		КонецЕсли;
		
		НачатьТранзакцию();
		Попытка
		    Блокировка = Новый БлокировкаДанных;
		    ЭлементБлокировки = Блокировка.Добавить(ОбщегоНазначения.ИмяТаблицыПоСсылке(ПодключенныйКорреспондент));
		    ЭлементБлокировки.УстановитьЗначение("Ссылка", ПодключенныйКорреспондент);
		    Блокировка.Заблокировать();
		    
			ЗаблокироватьДанныеДляРедактирования(ПодключенныйКорреспондент);
			КорреспондентОбъект = ПодключенныйКорреспондент.ПолучитьОбъект(); // ПланОбменаОбъект.ОбменСообщениями
			
			КорреспондентОбъект.Заблокирована = Истина;

		    КорреспондентОбъект.Записать();

		    ЗафиксироватьТранзакцию();
		Исключение
		    ОтменитьТранзакцию();
		    ВызватьИсключение;
		КонецПопытки;
		
	Иначе // Обновляем настройки подключения этой конечной точки и корреспондента.
		
		Отказ = Ложь;
		
		НастройкиПодключенияОтправителя = ОбменДаннымиСервер.СтруктураПараметровWS();
		НастройкиПодключенияОтправителя.WSURLВебСервиса = Тело.RecipientURL;
		НастройкиПодключенияОтправителя.WSИмяПользователя = Тело.RecipientUser;
		НастройкиПодключенияОтправителя.WSПароль = Тело.RecipientPassword;
		
		НастройкиПодключенияПолучателя = ОбменДаннымиСервер.СтруктураПараметровWS();
		НастройкиПодключенияПолучателя.WSURLВебСервиса = Тело.SenderURL;
		НастройкиПодключенияПолучателя.WSИмяПользователя = Тело.SenderUser;
		НастройкиПодключенияПолучателя.WSПароль = Тело.SenderPassword;
		
		МодульОбменСообщениями.ОбновитьНастройкиПодключенияКонечнойТочки(
									Отказ,
									Корреспондент,
									НастройкиПодключенияОтправителя,
									НастройкиПодключенияПолучателя);
		
		Если Отказ Тогда // Отправляем сообщение в менеджер сервиса об ошибке.
			
			ПредставлениеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Ошибка обновления параметров подключения этой конечной точки и конечной точки корреспондента обмена.
				|Код этой конечной токи %1
				|Код конечной точки корреспондента обмена %2'"),
				ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЭтотУзелОбменаСообщениями, "Код"),
				Тело.RecipientId);
				
			ОтправитьОтветноеСообщениеОбОшибкеПодключения(Сообщение, Отправитель, ПредставлениеОшибки);	
			Возврат;
			
		КонецЕсли;
		
		КорреспондентОбъект = Корреспондент.ПолучитьОбъект();
		КорреспондентОбъект.Заблокирована = Истина;
		КорреспондентОбъект.Записать();
		
	КонецЕсли;
	
	// Отправляем сообщение в менеджер сервиса об успешном выполнении операции.
	НачатьТранзакцию();
	Попытка
		ОтветноеСообщение = МодульСообщенияВМоделиСервиса.НовоеСообщение(
			СообщенияАдминистрированиеОбменаДаннымиКонтрольИнтерфейс.СообщениеКорреспондентУспешноПодключен());
		ОтветноеСообщение.Body.RecipientId = Тело.RecipientId;
		ОтветноеСообщение.Body.SenderId    = Тело.SenderId;
		МодульСообщенияВМоделиСервиса.ОтправитьСообщение(ОтветноеСообщение, Отправитель);
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

Процедура УстановитьНастройкиТранспорта(Сообщение, Отправитель)
	
	Тело = Сообщение.Body;
	
	Корреспондент = ОбменДаннымиВМоделиСервиса.МенеджерПланаОбменаКонечныхТочек().НайтиПоКоду(Тело.RecipientId);
	
	Если Корреспондент.Пустая() Тогда
		СтрокаСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не найдена конечная точка корреспондента с кодом ""%1"".'"),
			Тело.RecipientId);
		ВызватьИсключение СтрокаСообщения;
	КонецЕсли;
	
	ОбменДаннымиСервер.УстановитьКоличествоЭлементовВТранзакцииЗагрузкиДанных(Тело.ImportTransactionQuantity);
	
	СтруктураЗаписи = Новый Структура;
	СтруктураЗаписи.Вставить("КонечнаяТочкаКорреспондента", Корреспондент);
	
	СтруктураЗаписи.Вставить("FILEКаталогОбменаИнформацией",       Тело.FILE_ExchangeFolder);
	СтруктураЗаписи.Вставить("FILEСжиматьФайлИсходящегоСообщения", Тело.FILE_CompressExchangeMessage);
	
	СтруктураЗаписи.Вставить("FTPСжиматьФайлИсходящегоСообщения",                  Тело.FTP_CompressExchangeMessage);
	СтруктураЗаписи.Вставить("FTPСоединениеМаксимальныйДопустимыйРазмерСообщения", Тело.FTP_MaxExchangeMessageSize);
	СтруктураЗаписи.Вставить("FTPСоединениеПассивноеСоединение",                   Тело.FTP_PassiveMode);
	СтруктураЗаписи.Вставить("FTPСоединениеПользователь",                          Тело.FTP_User);
	СтруктураЗаписи.Вставить("FTPСоединениеПорт",                                  Тело.FTP_Port);
	СтруктураЗаписи.Вставить("FTPСоединениеПуть",                                  Тело.FTP_ExchangeFolder);
	
	СтруктураЗаписи.Вставить("ВидТранспортаСообщенийОбменаПоУмолчанию",      Перечисления.ВидыТранспортаСообщенийОбмена[Тело.ExchangeTransport]);
	
	
	УстановитьПривилегированныйРежим(Истина);
	ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(Корреспондент, Тело.FTP_Password, "FTPСоединениеПарольОбластейДанных");
	ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(Корреспондент, Тело.ExchangeMessagePassword, "ПарольАрхиваСообщенияОбменаОбластейДанных");
	УстановитьПривилегированныйРежим(Ложь);
	
	РегистрыСведений.НастройкиТранспортаОбменаОбластейДанных.ОбновитьЗапись(СтруктураЗаписи);
	
КонецПроцедуры

Процедура УдалитьНастройкуСинхронизации(Сообщение, Отправитель)
	
	Тело = Сообщение.Body;
	ОбменДаннымиВМоделиСервиса.УдалитьНастройкуСинхронизации(Тело.ExchangePlan, Формат(Тело.CorrespondentZone, "ЧЦ=7; ЧВН=; ЧГ=0"));
	
КонецПроцедуры

Процедура ВыполнитьСинхронизацию(Сообщение, Отправитель)
	
	СценарийОбменаДанными = СериализаторXDTO.ПрочитатьXDTO(Сообщение.Body.Scenario);
	
	ОбменДаннымиВМоделиСервиса.ВыполнитьОбменДанными(СценарийОбменаДанными);
	
КонецПроцедуры

Функция СобытиеЖурналаРегистрацииПодключениеКорреспондента()
	
	Возврат НСтр("ru = 'Обмен данными.Подключение корреспондента обмена'", ОбщегоНазначения.КодОсновногоЯзыка());
	
КонецФункции

Процедура ОтправитьОтветноеСообщениеОбОшибкеПодключения(Сообщение, Отправитель, ПредставлениеОшибки)
	
	НомерПопытки = Неопределено;
	Если Сообщение.Установлено("AdditionalInfo") Тогда
		ДополнительныеСвойства = СериализаторXDTO.ПрочитатьXDTO(Сообщение.AdditionalInfo);
		ДополнительныеСвойства.Свойство("НомерПопытки", НомерПопытки);
	КонецЕсли;
	
	ЗаписьЖурналаРегистрации(СобытиеЖурналаРегистрацииПодключениеКорреспондента(),
		УровеньЖурналаРегистрации.Ошибка,,, ПредставлениеОшибки);
	
	МодульСообщенияВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("СообщенияВМоделиСервиса");
	
	ОтветноеСообщение = МодульСообщенияВМоделиСервиса.НовоеСообщение(
		СообщенияАдминистрированиеОбменаДаннымиКонтрольИнтерфейс.СообщениеОшибкаПодключенияКорреспондента());
		
	ДополнительныеСвойства = Новый Структура;
	ДополнительныеСвойства.Вставить("НомерПопытки", НомерПопытки);
	ОтветноеСообщение.AdditionalInfo = СериализаторXDTO.ЗаписатьXDTO(ДополнительныеСвойства);
	ОтветноеСообщение.Body.RecipientId      = Сообщение.Body.RecipientId;
	ОтветноеСообщение.Body.SenderId         = Сообщение.Body.SenderId;
	ОтветноеСообщение.Body.ErrorDescription = ПредставлениеОшибки;
	
	НачатьТранзакцию();
	Попытка
		МодульСообщенияВМоделиСервиса.ОтправитьСообщение(ОтветноеСообщение, Отправитель);
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти
