﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	ЗаполнитьТаблицуСертификатов();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "СохраненПарольСертификата" Тогда
		ПриИзмененииСертификата();
		ТребуетсяПроверкаНастроек = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ТребуетсяПроверкаНастроек Тогда
		Оповестить("ПроверитьНастройкиРегламентныхЗаданий");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСертификаты

&НаКлиенте
Процедура СертификатыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле.Имя = "СертификатыСтатус" Тогда
		
		Если Не Элемент.ТекущиеДанные.Статус
			И ЗначениеЗаполнено(Элемент.ТекущиеДанные.Сертификат) Тогда
			
			ПараметрыФормы = КриптографияБЭДКлиент.НовыеПараметрыОткрытияФормыРедактированияПароляСертификата();
			ПараметрыФормы.Сертификат = Элемент.ТекущиеДанные.Сертификат;
			ПараметрыФормы.СохранятьДляВсех = Истина;
			
			ПараметрыОткрытия = ОбщегоНазначенияБЭДКлиент.НовыеПараметрыОткрытияФормы();
			ПараметрыОткрытия.Владелец = ЭтотОбъект;
			ПараметрыОткрытия.РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
			
			КриптографияБЭДКлиент.ОткрытьФормуРедактированияПароляСертификата(ПараметрыФормы, ПараметрыОткрытия);
			
		ИначеЕсли Не ЗначениеЗаполнено(Элемент.ТекущиеДанные.Сертификат) Тогда
			
			// Нет доступных сертификатов, позволим перейти на инструкцию в интернете.
			СсылкаНаИнструкцию = СинхронизацияЭДОСлужебныйКлиент.СсылкаНаИнструкциюПоНастройкеЭлектронногоДокументооборота();
			ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(СсылкаНаИнструкцию);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатыСертификатНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ИдентификаторЭДО = Элементы.Сертификаты.ТекущиеДанные.ИдентификаторЭДО;
	СертификатыУчетнойЗаписи = СписокСертификатовПоИдентификаторуЭДО(ИдентификаторЭДО);
	Элемент.СписокВыбора.ЗагрузитьЗначения(СертификатыУчетнойЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатыСертификатПриИзменении(Элемент)
	
	ПриИзмененииСертификата();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	// Надпись "сохраните пароль закрытого ключа", если пароль не сохранен.
	Элемент = УсловноеОформление.Элементы.Добавить();
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Сертификаты.ПодчиненныеЭлементы.СертификатыСтатус.Имя);
	
	ЭлементОтбора = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Сертификаты.Статус");
	ЭлементОтбора.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.ПравоеЗначение = Ложь;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='сохраните пароль закрытого ключа'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветОсобогоТекста);
	
	// Надпись "Действий не требуется", если пароль сохранен.
	Элемент = УсловноеОформление.Элементы.Добавить();
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Сертификаты.ПодчиненныеЭлементы.СертификатыСтатус.Имя);
	
	ЭлементОтбора = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Сертификаты.Статус");
	ЭлементОтбора.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='действий не требуется'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ПоясняющийТекст);
	
	// Надпись "нет доступных сертификатов" для профилей без сертификатов.
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Сертификаты.ПодчиненныеЭлементы.СертификатыСертификат.Имя);
	
	ЭлементОтбора = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Сертификаты.Сертификат");
	ЭлементОтбора.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.ПравоеЗначение = Справочники.СертификатыКлючейЭлектроннойПодписиИШифрования.ПустаяСсылка();
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='нет доступных сертификатов'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветОсобогоТекста);
	
	// Надпись "установите контейнер закрытого ключа на сервере" если нет доступных сертификатов.
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Сертификаты.ПодчиненныеЭлементы.СертификатыСтатус.Имя);
	
	ЭлементОтбора = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Сертификаты.Сертификат");
	ЭлементОтбора.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.ПравоеЗначение = Справочники.СертификатыКлючейЭлектроннойПодписиИШифрования.ПустаяСсылка();
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='установите контейнер закрытого ключа на сервере'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветОсобогоТекста);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуСертификатов()
	
	РезультатЗапроса = РезультатЗапросаСертификатов();
	
	ВыборкаУчетныхЗаписей = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаУчетныхЗаписей.Следующий() Цикл
		
		СтрокаТаблицы = Сертификаты.Добавить();
		СтрокаТаблицы.ИдентификаторЭДО = ВыборкаУчетныхЗаписей.ИдентификаторЭДО;
		
		ВыборкаСертификат = ВыборкаУчетныхЗаписей.Выбрать();
		Пока ВыборкаСертификат.Следующий() Цикл
			
			СтрокаТаблицы.НаименованиеУчетнойЗаписи = ВыборкаСертификат.НаименованиеУчетнойЗаписи;
			
			Если ЗначениеЗаполнено(ВыборкаСертификат.Сертификат) Тогда
				
				СтрокаТаблицы.Сертификат = ВыборкаСертификат.Сертификат;
				СтрокаТаблицы.Статус     = ПарольСертификатаСохраненДляВсех(ВыборкаСертификат.Сертификат);
				
				Если СтрокаТаблицы.Статус Тогда
					Прервать;
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция РезультатЗапросаСертификатов(ИдентификаторЭДО = Неопределено)
	
	Возврат Обработки.СинхронизацияЭДО.РезультатЗапросаСертификатов(ИдентификаторЭДО);
	
КонецФункции

&НаСервереБезКонтекста
Функция СписокСертификатовПоИдентификаторуЭДО(Знач ИдентификаторЭДО)
	
	Список = Новый Массив;
	
	РезультатЗапроса = РезультатЗапросаСертификатов(ИдентификаторЭДО);
	ВыборкаУчетныхЗаписей = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	ВыборкаУчетныхЗаписей.Следующий();
	
	ВыборкаСертификаты = ВыборкаУчетныхЗаписей.Выбрать();
	Пока ВыборкаСертификаты.Следующий() Цикл
		Список.Добавить(ВыборкаСертификаты.Сертификат);
	КонецЦикла;
	
	Возврат Список;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПарольСертификатаСохраненДляВсех(Знач Сертификат)
	
	Возврат КриптографияБЭД.ПарольСертификатаСохраненДляВсех(Сертификат);
	
КонецФункции

&НаКлиенте
Процедура ПриИзмененииСертификата()
	
	ТекущиеДанные = Элементы.Сертификаты.ТекущиеДанные;
	
	Если ЗначениеЗаполнено(ТекущиеДанные.Сертификат) Тогда
		ТекущиеДанные.Статус = ПарольСертификатаСохраненДляВсех(ТекущиеДанные.Сертификат);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти