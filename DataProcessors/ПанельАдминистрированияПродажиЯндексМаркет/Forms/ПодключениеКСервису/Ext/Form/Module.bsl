﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("ИдентификаторАккаунта", ИдентификаторАккаунта);
	 
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Оповестить("ЯндексМаркет_ПодключениеКСервису", ИдентификаторАккаунта);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ГиперссылкаПерейтиНаСайтЯндексНажатие(Элемент)
	
	Адрес = АдресАвторизации();
	
	ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(Адрес);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключить(Команда)
	
	Если ОбязательныеПоляЗаполнены() Тогда
		Идентификатор = Неопределено;
		Результат     = ПодключитьНаСервере(Идентификатор);
		
		Если Результат = Неопределено Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'При выполнении запроса к интернет-ресурсу возникли ошибки. Подробности см. в журнале регистрации.'"));
			Возврат;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ИдентификаторАккаунта)
			 И ИдентификаторАккаунта <> Идентификатор Тогда
			ПоказатьПредупреждение(, 
				НСтр("ru = 'Данные авторизации не совпадают с данными текущего аккаунта. Проверьте имя пользователя на странице авторизации Яндекс.'"),
				,
				НСтр("ru = 'Яндекс Маркет'"));
			Возврат;
		КонецЕсли;
		
		ИдентификаторАккаунта = Идентификатор;
		
		#Если ВебКлиент Или МобильныйКлиент Тогда
			Если Результат = Истина Тогда
				ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Авторизация пройдена.'"));
			Иначе
				ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Ошибка авторизации.'"));
			КонецЕсли;
			
			Закрыть(ИдентификаторАккаунта);
			
		#Иначе                
			РезультатВыводаСтраницы = ПоказатьСтраницуСРезультатамиАвторизации(Результат);
			Если Не РезультатВыводаСтраницы Тогда  
				Если Результат = Истина Тогда
					ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Авторизация пройдена.';
					|en = 'Authorization is completed.'"));
				Иначе
					ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Ошибка авторизации.';
					|en = 'Authorization error.'"));
				КонецЕсли;
			КонецЕсли;	
		#КонецЕсли
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ОтменаПодключения(Команда)
	
	ИдентификаторАккаунта = Неопределено;
	Закрыть(Неопределено);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция АдресАвторизации()
	
	Адрес = ИнтеграцияСЯндексМаркетСервер.АдресАвторизации();
	
	Возврат Адрес;

КонецФункции

&НаКлиенте
Функция ОбязательныеПоляЗаполнены()
	
	Результат = Истина;
	ОчиститьСообщения();
	
	Если Не ЗначениеЗаполнено(ВременныйКод) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Заполните временный код'"));
		Результат = Ложь;
	КонецЕсли;
	
	Возврат Результат; 
	
КонецФункции

&НаСервере
Функция ПодключитьНаСервере(Идентификатор)
	
	Идентификатор = Неопределено;
	Результат     = Неопределено;
	
	Попытка
		Сервер         = ИнтеграцияСЯндексМаркетСервер.СерверАвторизации();
		ИнтернетПрокси = Неопределено;
		Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ПолучениеФайловИзИнтернета") Тогда
			МодульПолучениеФайловИзИнтернета = ОбщегоНазначения.ОбщийМодуль("ПолучениеФайловИзИнтернета");
			ИнтернетПрокси = МодульПолучениеФайловИзИнтернета.ПолучитьПрокси("https");
		КонецЕсли;
		СоединениеOpenSSL = ОбщегоНазначенияКлиентСервер.НовоеЗащищенноеСоединение();
		HTTPСоединение = Новый HTTPСоединение(Сервер,,,,ИнтернетПрокси,60,СоединениеOpenSSL);

		HTTPЗапрос = ИнтеграцияСЯндексМаркетСервер.ЗапросПолучитьТокеныПоКоду(ВременныйКод);
		
		HTTPОтвет    = HTTPСоединение.ОтправитьДляОбработки(HTTPЗапрос);  
		КодСостояния = HTTPОтвет.КодСостояния; 
		СтрокаОтвета = HTTPОтвет.ПолучитьТелоКакСтроку();
	
		Если КодСостояния = 200  Тогда
	    	СтруктураОтвета   = ИнтеграцияСЯндексМаркетСервер.ИзJSON(СтрокаОтвета);
			ДанныеАвторизации = ИнтеграцияСЯндексМаркетСервер.ДанныеАвторизации(СтруктураОтвета);  
			ДанныеЛогина      = ИнтеграцияСЯндексМаркетСервер.ПолучитьДанныеЛогина(ДанныеАвторизации.access_token);
			Идентификатор     = ДанныеЛогина.Идентификатор;
			
			Если ИнтеграцияСЯндексМаркетСервер.УстановитьНастройкиАвторизации(ДанныеАвторизации, ДанныеЛогина) Тогда	
				Результат = Истина;
			Иначе 
				Результат = Ложь;
			КонецЕсли;
			
		Иначе
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Ошибка выполнения запроса %1: %2'", 
					ОбщегоНазначения.КодОсновногоЯзыка()), 
				Сервер, 
				СтрокаОтвета);
			ЗаписьЖурналаРегистрации(ИнтеграцияСЯндексМаркетСервер.СобытиеЖурналаРегистрации(), 
				УровеньЖурналаРегистрации.Ошибка,,, 
				ТекстОшибки);
		КонецЕсли;
			
	Исключение
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Отсутствует соединение с сервером %1 по причине: %2'", 
				ОбщегоНазначения.КодОсновногоЯзыка()),
			Сервер,
			ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ЗаписьЖурналаРегистрации(ИнтеграцияСЯндексМаркетСервер.СобытиеЖурналаРегистрации(), 
			УровеньЖурналаРегистрации.Ошибка,,, 
			ТекстОшибки);
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ПутьКФайлуМакета(АвторизацияУспешна)  
	
	КаталогВременныхФайлов = ФайловаяСистема.СоздатьВременныйКаталог();
	СоздатьКаталог(КаталогВременныхФайлов);
		
	Если АвторизацияУспешна Тогда
		ИмяФайла = "УспешнаяАвторизация.html";
	Иначе
		ИмяФайла = "НеУспешнаяАвторизация.html";
	КонецЕсли;

	ПутьКФайлу = КаталогВременныхФайлов + ИмяФайла;
	
	МассивНайденныхФайлов = НайтиФайлы(КаталогВременныхФайлов, ИмяФайла, Ложь);
	
	Если МассивНайденныхФайлов.Количество() = 0 Тогда
		ТекстовыйДокумент = Новый ТекстовыйДокумент;
		ТекстСтраницы = ТекстСтраницы(ПутьКФайлу, АвторизацияУспешна);
		ТекстовыйДокумент.УстановитьТекст(ТекстСтраницы);
		ТекстовыйДокумент.Записать(ПутьКФайлу);
	КонецЕсли;
	
	Возврат ПутьКФайлу;
	
КонецФункции

&НаКлиенте
Функция ПоказатьСтраницуСРезультатамиАвторизации(АвторизацияУспешна)
	
	Результат = Истина;

	Попытка	
		ПутьКФайлу = ПутьКФайлуМакета(АвторизацияУспешна);
		ФайловаяСистемаКлиент.ОткрытьФайл(ПутьКФайлу);
		Закрыть(ИдентификаторАккаунта);
	Исключение
		ДобавитьЗаписьВЖурналРегистрации(ПутьКФайлу);
		Результат = Ложь;
	КонецПопытки;

	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ТекстСтраницы(ПутьКФайлу, АвторизацияУспешна)
	
	Если АвторизацияУспешна Тогда
		ТекстСтраницы = ПолучитьОбщийМакет("УспешнаяАвторизация").ПолучитьТекст();
	Иначе
		ТекстСтраницы = ПолучитьОбщийМакет("НеУспешнаяАвторизация").ПолучитьТекст();
	КонецЕсли;
	
	ТекстСтраницы = СтрЗаменить(ТекстСтраницы, 
		НСтр("ru = 'Все права защищены'"),
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = '© ООО 1С-Софт, %1. Все права защищены'"),
			Формат(Год(ТекущаяДатаСеанса()), "ЧГ=0")));
	
	Возврат ТекстСтраницы;
	
КонецФункции

&НаСервере
Процедура ДобавитьЗаписьВЖурналРегистрации(ПутьКФайлу)
	
	ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Не удалось открыть приложение по адресу %1 по причине: %2'", 
			ОбщегоНазначения.КодОсновногоЯзыка()), 
		ПутьКФайлу, 
		ОписаниеОшибки());
	ЗаписьЖурналаРегистрации(ИнтеграцияСЯндексМаркетСервер.СобытиеЖурналаРегистрации(), 
		УровеньЖурналаРегистрации.Ошибка,,, 
		ТекстОшибки);
	
КонецПроцедуры

#КонецОбласти

