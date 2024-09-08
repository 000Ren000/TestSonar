﻿
#Область СлужебныйПрограммныйИнтерфейс

// См. ОбработкаНеисправностейБЭДСобытия.ПриФормированииФайлаСИнформациейДляТехподдержки
Процедура ПриФормированииФайлаСИнформациейДляТехподдержки(Текст, ТехническаяИнформация) Экспорт
	
	Текст = Текст + НСтр("ru = 'Версия прикладного решения: [ВерсияПрикладногоРешения];
					   |Версия БЭД: [ВерсияБЭД];
					   |Версия Платформы 1С:Предприятие: [ВерсияПлатформы];
					   |Режим: [Режим];
					   |Криптопровайдер (клиент): [КриптопровайдерКлиент];
					   |Криптопровайдер (сервер): [КриптопровайдерСервер];
					   |Логин для подключения Интернет-поддержки: [ЛогинИнтернетПоддержка];
					   |Пароль для подключения Интернет-поддержки: [ПарольИнтернетПоддержкаЗаполнен];
					   |Параметры клиента: [ПараметрыКлиента];'"); 
	
	ПараметрыКлиентаНаСервере = ПараметрыСеанса.ПараметрыКлиентаНаСервере;
	
	ПараметрыКлиента = Новый Массив;
	ПараметрыКлиента.Добавить("ЭтоLinuxКлиент");
	ПараметрыКлиента.Добавить("ЭтоWindowsКлиент");
	ПараметрыКлиента.Добавить("ЭтоВебКлиент");
	ПараметрыКлиента.Добавить("ЭтоМобильныйКлиент");
	ПараметрыКлиента.Добавить("ИспользуемыйКлиент");
	ПараметрыКлиента.Добавить("ЭтоOSXКлиент");
	
	ПараметрыКлиентаКопия = Новый Массив;
	Для каждого Параметр Из ПараметрыКлиентаНаСервере Цикл
		Если ПараметрыКлиента.Найти(Параметр.Ключ) <> Неопределено Тогда
			ПараметрыКлиентаКопия.Добавить(Параметр.Ключ + ": " + Параметр.Значение);
		КонецЕсли;
	КонецЦикла;
	ПараметрыКлиентаСтрока = Символы.ПС + "{" + Символы.ПС + СтрСоединить(ПараметрыКлиентаКопия, Символы.ПС) + Символы.ПС + "}";
	
	ЭтоФайловаяИБ = ОбщегоНазначения.ИнформационнаяБазаФайловая();
	
	УстановитьПривилегированныйРежим(Истина);
	ДанныеАутентификации = ИнтернетПоддержкаПользователей.ДанныеАутентификацииПользователяИнтернетПоддержки();
	УстановитьПривилегированныйРежим(Ложь);
	Логин = "";
	ПарольЗаполнен = Ложь;
	Если ДанныеАутентификации <> Неопределено Тогда
		Логин = ДанныеАутентификации.Логин;
		ПарольЗаполнен = ЗначениеЗаполнено(ДанныеАутентификации.Пароль);
	КонецЕсли;
	
	СистемнаяИнформация = Новый СистемнаяИнформация;
	ВерсияПлатформы = СистемнаяИнформация.ВерсияПриложения;
	
	МенеджерКриптографии = ЭлектроннаяПодпись.МенеджерКриптографии("", Ложь);
	Если МенеджерКриптографии <> Неопределено Тогда
		ИнформацияМодуляКриптографии = МенеджерКриптографии.ПолучитьИнформациюМодуляКриптографии();
		Криптопровайдер = ИнформацияМодуляКриптографии.Имя;
	Иначе 
		Криптопровайдер = НСтр("ru = 'Не известно'"); 
	КонецЕсли;
	
	ТехническаяИнформация.Вставить("ПараметрыКлиента", ПараметрыКлиентаСтрока);
	ТехническаяИнформация.Вставить("Режим", ?(ЭтоФайловаяИБ, НСтр("ru = 'Файловый'"), НСтр("ru = 'Серверный'")));
	ТехническаяИнформация.Вставить("ЛогинИнтернетПоддержка", Логин);
	ТехническаяИнформация.Вставить("ПарольИнтернетПоддержкаЗаполнен", ?(ПарольЗаполнен, НСтр("ru = 'Заполнен'"), НСтр("ru = 'Не заполнен'")));
	ТехническаяИнформация.Вставить("ВерсияПлатформы", ВерсияПлатформы);
	ТехническаяИнформация.Вставить("ВерсияПрикладногоРешения", СтрШаблон(НСтр("ru = 'Версия прикладного решения: %1 (%2)'"),
		Метаданные.Синоним, Метаданные.Версия));
	ТехническаяИнформация.Вставить("ВерсияБЭД", ОбновлениеИнформационнойБазыБЭД.ВерсияБиблиотеки());
	ТехническаяИнформация.Вставить("КриптопровайдерСервер", Криптопровайдер);
	
КонецПроцедуры

// См. ОбработкаНеисправностейБЭДСобытия.ПриФормированииФайловДляТехподдержки
Процедура ПриФормированииФайловДляТехподдержки(ФайлыДляТехподдержки, КонтекстДиагностики) Экспорт
	
	Ошибки = ОбработкаНеисправностейБЭДКлиентСервер.ПолучитьОшибки(КонтекстДиагностики);
	Для каждого Ошибка Из Ошибки Цикл
		
		Если ТипЗнч(Ошибка.СсылкаНаОбъект) = Тип("ДокументСсылка.ТранспортныйКонтейнерЭДО") Тогда
			ДобавитьТранспортныйКонтейнерВФайлыДляТехподдержки(Ошибка.СсылкаНаОбъект, ФайлыДляТехподдержки);
		КонецЕсли;
		
		Если Ошибка.ДополнительныеДанные <> Неопределено Тогда
			ДополнительныеСвойстваОшибки = ДиагностикаЭДОКлиентСервер.НовыеДополнительныеСвойстваОшибки();
			ЗаполнитьЗначенияСвойств(ДополнительныеСвойстваОшибки, Ошибка.ДополнительныеДанные);
			Для каждого ЭлементДанных Из ДополнительныеСвойстваОшибки.ДанныеДляФормированияФайловДляТехподдержки Цикл
				Если ТипЗнч(ЭлементДанных) = Тип("ДвоичныеДанные") Тогда
					ДобавитьТранспортныйКонтейнерВФайлыДляТехподдержки(ЭлементДанных, ФайлыДляТехподдержки);
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Выполняет диагностику и записывает результат в журнал регистрации. Вызывается после завершения операции.
//
// Параметры:
//  КонтекстДиагностики - см. ОбработкаНеисправностейБЭД.НовыйКонтекстДиагностики
Процедура ОбработатьОшибки(КонтекстДиагностики) Экспорт
	
	Ошибки = ОбработкаНеисправностейБЭДКлиентСервер.ПолучитьОшибки(КонтекстДиагностики);
	ВидыДиагностики = Новый Массив;
	Если ДиагностикаЭДОКлиентСервер.ОшибкиДиагностируются(Ошибки, ВидыДиагностики) Тогда
		ПараметрыВыполненияДиагностики = ДиагностикаЭДОКлиентСервер.НовыеПараметрыВыполненияДиагностики();
		
		ПараметрыВыполненияДиагностики.ВидыДиагностики = ВидыДиагностики;
		РезультатДиагностики = ДиагностикаЭДОСлужебный.ВыполнитьДиагностику(ПараметрыВыполненияДиагностики);
		
		ТекстыОтчетов = Новый Массив;
		Для каждого КлючИЗначение Из РезультатДиагностики.Результаты Цикл
			Отчет = КлючИЗначение.Значение.ОтчетДляАдминистратора;
			ТекстыОтчетов.Добавить(Отчет.Текст);
		КонецЦикла;
		
		ТекстОтчета = СтрСоединить(ТекстыОтчетов, Символы.ПС);
		
		ШаблонСообщения = НСтр("ru = 'Результат диагностики ЭДО:
									 |%1'");
		ТекстСообщения = Символы.ПС + СтрШаблон(ШаблонСообщения, ТекстОтчета);
		ОбработкаНеисправностейБЭД.ОбработатьОшибку(НСтр("ru = 'Выполнение диагностики ЭДО'"),
			ОбщегоНазначенияБЭДКлиентСервер.ПодсистемыБЭД().ОбменСКонтрагентами , ТекстСообщения);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ДобавитьТранспортныйКонтейнерВФайлыДляТехподдержки(ТранспортныйКонтейнер, ФайлыДляТехподдержки) 
	
	Если ТипЗнч(ТранспортныйКонтейнер) = Тип("ДокументСсылка.ТранспортныйКонтейнерЭДО") Тогда
		ПрисоединенныеФайлыКонтейнеров = ТранспортныеКонтейнерыЭДО.ПрисоединенныеФайлыКонтейнеров(
		ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ТранспортныйКонтейнер));
		ПрисоединенныеФайлыКонтейнера = ПрисоединенныеФайлыКонтейнеров[ТранспортныйКонтейнер];
		Если ПрисоединенныеФайлыКонтейнера <> Неопределено Тогда
			Для Каждого ПрисоединенныйФайлКонтейнера Из ПрисоединенныеФайлыКонтейнера Цикл
				ДвоичныеДанные = РаботаСФайлами.ДвоичныеДанныеФайла(ПрисоединенныйФайлКонтейнера);
				ДобавитьФайлВФайлыДляТехподдержки(ДвоичныеДанные, ФайлыДляТехподдержки);
			КонецЦикла;
		КонецЕсли;
	Иначе
		ДвоичныеДанные = ТранспортныйКонтейнер;
		ДобавитьФайлВФайлыДляТехподдержки(ДвоичныеДанные, ФайлыДляТехподдержки);
	КонецЕсли;
	
КонецПроцедуры

Процедура ДобавитьФайлВФайлыДляТехподдержки(ДвоичныеДанные, ФайлыДляТехподдержки)
	
	ОписаниеФайла = РаботаСФайламиБЭДКлиентСервер.НовоеОписаниеФайла();
	ИмяФайла = "" + Новый УникальныйИдентификатор + ".zip";
	ОписаниеФайла.ИмяФайла = ОбщегоНазначенияКлиентСервер.ЗаменитьНедопустимыеСимволыВИмениФайла(ИмяФайла);
	ОписаниеФайла.ДвоичныеДанные = ДвоичныеДанные;
	ФайлыДляТехподдержки.Добавить(ОписаниеФайла);
	
КонецПроцедуры

#КонецОбласти
