﻿#Область ОписаниеПеременных

&НаКлиенте
Перем КэшированныеЗначения; //используется механизмом обработки изменения реквизитов ТЧ

&НаКлиенте
Перем ТекущиеДанныеИдентификатор; //используется для передачи текущей строки в обработчик ожидания

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если ТребуетсяОткрытиеПечатнойФормы Тогда
		Возврат;
	КонецЕсли;
	
	// Обработчик механизма "ВерсионированиеОбъектов"
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	ИспользоватьСоглашенияСКлиентами = ПолучитьФункциональнуюОпцию("ИспользоватьСоглашенияСКлиентами");
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		СамообслуживаниеСервер.ФормыСамообслуживаниеПриСозданииНаСервере(ЭтаФорма, Отказ);
		Если Отказ Тогда
			Возврат;
		КонецЕсли;
		
		Объект.Статус = Перечисления.СтатусыЗаявокНаВозвратТоваровОтКлиентов.НеСогласована;
		Объект.Приоритет = Справочники.Приоритеты.ПолучитьПриоритетПоУмолчанию(Объект.Приоритет);
		
		ПриЧтенииСозданииНаСервере();
		НоменклатураСервер.ЗаполнитьСтатусыУказанияСерий(Объект, ПараметрыУказанияСерий.Возвращаемые);
		УстановитьЗаголовокДокумента(Истина);
		
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	Если КлиентскоеПриложение.ТекущийВариантИнтерфейса() = ВариантИнтерфейсаКлиентскогоПриложения.Версия8_2 Тогда
		Элементы.ГруппаИтого.ЦветФона = Новый Цвет();
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ПриЧтенииСозданииНаСервере();
	
	УстановитьЗаголовокДокумента(Ложь);
	Элементы.СтраницаДополнительнаяИнформация.Картинка = ОбщегоНазначенияКлиентСервер.КартинкаКомментария(Объект.ДополнительнаяИнформация);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ТребуетсяОткрытиеПечатнойФормы Тогда
		
		Отказ = Истина;
		СамообслуживаниеКлиент.ПечатьДокументЗаявкаНаВозврат(Объект.Ссылка);
		
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	Элементы.СтраницаДополнительнаяИнформация.Картинка = ОбщегоНазначенияКлиентСервер.КартинкаКомментария(Объект.ДополнительнаяИнформация);

	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ЗаполнитьПризнакХарактеристикиИспользуются", Новый Структура("Номенклатура", "ХарактеристикиИспользуются"));
	СтруктураДействий.Вставить("ЗаполнитьПризнакТипНоменклатуры", Новый Структура("Номенклатура", "ТипНоменклатуры"));
	СтруктураДействий.Вставить("ЗаполнитьПризнакАртикул", Новый Структура("Номенклатура", "Артикул"));
	
	ПараметрыУказанияСерий = Новый ФиксированнаяСтруктура(НоменклатураСервер.ПараметрыУказанияСерий(Объект, Документы.ЗаявкаНаВозвратТоваровОтКлиента));
	УстановитьВидимостьЭлементовСерий();
	
	НоменклатураСервер.ЗаполнитьСлужебныеРеквизитыПоНоменклатуреВКоллекции(Объект.ВозвращаемыеТовары, СтруктураДействий);
	УстановитьЗаголовокДокумента(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
		МодульПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ИсточникВыбора.ИмяФормы = "ОбщаяФорма.ПодборТоваровПоРеализациямИПередачам" Тогда
		
		ОбработкаВыбораПодборПоРеализацииСервер(ВыбранноеЗначение);
		
	КонецЕсли;
	
	Если Окно <> Неопределено Тогда
		Окно.Активизировать();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НадписьЗаголовокРеализацииНажатие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	ОткрытьФорму(
		"ОбщаяФорма.ПросмотрСпискаДокументов",
		Новый Структура("СписокДокументов, Заголовок",
			СписокРеализаций,
			НСтр("ru='Документы продаж (%КоличествоДокументов%)'")
		),
		ЭтаФорма,,,, Неопределено, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);

КонецПроцедуры

&НаКлиенте
Процедура СкладПриИзменении(Элемент)
	
	СкладПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура СоглашениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	РезультатВыбора = Неопределено;

	ОткрытьФорму("Обработка.СамообслуживаниеПартнеров.Форма.ВыборСоглашения",
	                                       Новый Структура("Партнер,Соглашение",Объект.Партнер,Объект.Соглашение),
	                                       ЭтаФорма,,,, Новый ОписаниеОповещения("СоглашениеНачалоВыбораЗавершение", ЭтотОбъект), РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура СоглашениеНачалоВыбораЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	РезультатВыбора = Результат;
	
	Если РезультатВыбора <> Неопределено И РезультатВыбора.Соглашение <> Объект.Соглашение Тогда
		
		Если Объект.ВозвращаемыеТовары.Количество() > 0 Тогда
			ДополнительныеПараметры = Новый Структура;
			ДополнительныеПараметры.Вставить("РезультатВыбора", РезультатВыбора);
			ТекстВопроса = НСтр("ru = 'Соглашение было изменено, ""Возвращаемые товары"" будут очищены, Продолжить?'");
			ПоказатьВопрос(
				Новый ОписаниеОповещения("СоглашениеНачалоВыбораВопросВозвращаемыеТоварыБудутОчищеныЗавершение", ЭтотОбъект, ДополнительныеПараметры),
				ТекстВопроса,
				РежимДиалогаВопрос.ДаНет);
			Возврат;
		КонецЕсли;
		
		Объект.Соглашение = РезультатВыбора.Соглашение;
		СоглашениеПриИзмененииСервер(РезультатВыбора);
		
	КонецЕсли;
	
	УправлениеДоступностью(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СоглашениеНачалоВыбораВопросВозвращаемыеТоварыБудутОчищеныЗавершение(Ответ, ДополнительныеПараметры) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		Объект.ВозвращаемыеТовары.Очистить();
		Объект.ВозвращаемыеСерии.Очистить();
	КонецЕсли;
	
	Объект.Соглашение = ДополнительныеПараметры.РезультатВыбора.Соглашение;
	СоглашениеПриИзмененииСервер(ДополнительныеПараметры.РезультатВыбора);
	
	УправлениеДоступностью(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СоглашениеОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ВыбранноеЗначение <> ТекущееЗначениеКонтрагента Тогда
		Если Объект.ВозвращаемыеТовары.Количество() > 0 Тогда
			ТекстВопроса = НСтр("ru = 'Контрагент был изменен, ""Возвращаемые товары"" будут очищены, Продолжить?'");
			Ответ = Неопределено;

			ПоказатьВопрос(Новый ОписаниеОповещения("КонтрагентОбработкаВыбораЗавершение", ЭтотОбъект, Новый Структура("ВыбранноеЗначение", ВыбранноеЗначение)), ТекстВопроса,РежимДиалогаВопрос.ДаНет);
            Возврат;
		КонецЕсли;
	КонецЕсли;
	
	КонтрагентОбработкаВыбораФрагмент(ВыбранноеЗначение);
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентОбработкаВыбораЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    ВыбранноеЗначение = ДополнительныеПараметры.ВыбранноеЗначение;
    
    
    Ответ = РезультатВопроса;
    Если Ответ <> КодВозвратаДиалога.Да Тогда
        Возврат;
    Иначе
        Объект.Договор = ПредопределенноеЗначение("Справочник.Контрагенты.ПустаяСсылка");
        Объект.ВозвращаемыеТовары.Очистить();
        Объект.ВозвращаемыеСерии.Очистить();
    КонецЕсли;
    
    КонтрагентОбработкаВыбораФрагмент(ВыбранноеЗначение);

КонецПроцедуры

&НаКлиенте
Процедура КонтрагентОбработкаВыбораФрагмент(Знач ВыбранноеЗначение)
    
    Объект.Контрагент = ВыбранноеЗначение;
    ТекущееЗначениеКонтрагента = Объект.Контрагент;
    
    Если ИспользуютсяДоговорыКонтрагентов Тогда
        КонтрагентПриИзмененииСервер();
    КонецЕсли;
    УправлениеДоступностью(ЭтаФорма);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыВозвращаемыеТовары

&НаКлиенте
Процедура ВозвращаемыеТоварыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле = Элементы.ВозвращаемыеТоварыСтатусУказанияСерий
		Или Поле = Элементы.ВозвращаемыеТоварыСерия Тогда
		
		ОткрытьПодборСерий();
		
	ИначеЕсли Поле = Элементы.ВозвращаемыеТоварыАртикул ИЛИ Поле = Элементы.ВозвращаемыеТоварыТипНоменклатуры 
		ИЛИ Поле = Элементы.ВозвращаемыеТоварыНоменклатура ИЛИ Поле = Элементы.ВозвращаемыеТоварыХарактеристика Тогда
		
		ОткрытьКарточкуНоменклатуры();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВозвращаемыеТоварыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ВозвращаемыеТоварыПриИзменении(Элемент)
	
	УправлениеДоступностью(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ВозвращаемыеТоварыПослеУдаления(Элемент)
	
	Если НоменклатураКлиент.НеобходимоОбновитьСтатусыСерий(
			Элемент,КэшированныеЗначения,ПараметрыУказанияСерий.Возвращаемые,Истина) Тогда
		
		ЗаполнитьСтатусыУказанияСерийПриОкончанииРедактированияСтрокиТЧ(Неопределено, КэшированныеЗначения,"Возвращаемые");
		НоменклатураКлиент.ОбновитьКешированныеЗначенияДляУчетаСерий(
			Элемент,КэшированныеЗначения,ПараметрыУказанияСерий.Возвращаемые);
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВозвращаемыеТоварыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		Элементы.ВозвращаемыеТовары.ТекущиеДанные.КодСтроки = 0;
	КонецЕсли;
	
	НоменклатураКлиент.ОбновитьКешированныеЗначенияДляУчетаСерий(
		Элемент,КэшированныеЗначения,ПараметрыУказанияСерий.Возвращаемые, Копирование);
	
КонецПроцедуры

&НаКлиенте
Процедура ВозвращаемыеТоварыПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	ТекущиеДанные = Элементы.ВозвращаемыеТовары.ТекущиеДанные;
	
	Если НоменклатураКлиент.НеобходимоОбновитьСтатусыСерий(
		Элемент,КэшированныеЗначения,ПараметрыУказанияСерий.Возвращаемые) Тогда
		
		ТекущаяСтрокаИдентификатор = ТекущиеДанные.ПолучитьИдентификатор();
		
		ЗаполнитьСтатусыУказанияСерийПриОкончанииРедактированияСтрокиТЧ(ТекущаяСтрокаИдентификатор, КэшированныеЗначения,"Возвращаемые");
		НоменклатураКлиент.ОбновитьКешированныеЗначенияДляУчетаСерий(Элемент,КэшированныеЗначения,ПараметрыУказанияСерий.Возвращаемые);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВозвращаемыеТоварыПередУдалением(Элемент, Отказ)
	
	НоменклатураКлиент.ОбновитьКешированныеЗначенияДляУчетаСерий(
		Элемент,КэшированныеЗначения,ПараметрыУказанияСерий.Возвращаемые);
	
КонецПроцедуры

&НаКлиенте
Процедура ВозвращаемыеТоварыСерияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ОткрытьПодборСерий();
КонецПроцедуры

&НаКлиенте
Процедура ВозвращаемыеТоварыСерияАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	Если Не ПустаяСтрока(Текст) Тогда
		СтандартнаяОбработка = Ложь;
		ОткрытьПодборСерий(Текст);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВозвращаемыеТоварыСерияОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	Если Не ПустаяСтрока(Текст) Тогда
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = Новый СписокЗначений;
		ДанныеВыбора.Добавить(Элементы.ВозвращаемыеТовары.ТекущиеДанные.Серия);
		ОткрытьПодборСерий(Текст);
	Иначе
		ВыбранноеЗначение = НоменклатураКлиентСервер.ВыбраннаяСерия();
		
		ВыбранноеЗначение.Значение            		 = ПредопределенноеЗначение("Справочник.СерииНоменклатуры.ПустаяСсылка");
		ВыбранноеЗначение.ИдентификаторТекущейСтроки = Элементы.ВозвращаемыеТовары.ТекущиеДанные.ПолучитьИдентификатор();
		
		НоменклатураКлиент.ОбработатьУказаниеСерии(ЭтаФорма,
													ПараметрыУказанияСерий.Возвращаемые,
													ВыбранноеЗначение);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВозвращаемыеТоварыКоличествоУпаковокПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.ВозвращаемыеТовары.ТекущиеДанные;
	
	СтруктураДействий = Новый Структура;
	СамообслуживаниеКлиентСервер.ДобавитьВСтруктуруДействияПриИзмененииКоличестваУпаковокВозвращаемыеТоварыОбщее(СтруктураДействий, Объект);
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	РассчитатьИтоговыеПоказателиЗаявкиНаВозврат(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УказатьСерииВозвращаемые(Команда)
	
	ОткрытьПодборСерий();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКарточкуТовара(Команда)
	
	ОткрытьКарточкуНоменклатуры();
	
КонецПроцедуры

&НаКлиенте
Процедура ПодобратьТоварыПоРеализациям(Команда)
	
	ПараметрыПодбора = Новый Структура;
	ПараметрыПодбора.Вставить("Партнер",Объект.Партнер);
	ПараметрыПодбора.Вставить("ДокументВозврата",Объект.Ссылка);
	ПараметрыПодбора.Вставить("Валюта", Объект.Валюта);
	ПараметрыПодбора.Вставить("Дата",?(ЗначениеЗаполнено(Объект.Дата), Объект.Дата, ОбщегоНазначенияКлиент.ДатаСеанса()));
	ПараметрыПодбора.Вставить("НалогообложениеНДС", Объект.НалогообложениеНДС);
	ПараметрыПодбора.Вставить("ЦенаВключаетНДС",Объект.ЦенаВключаетНДС);
	ПараметрыПодбора.Вставить("Соглашение", Объект.Соглашение);
	ПараметрыПодбора.Вставить("Договор", Объект.Договор);
	ПараметрыПодбора.Вставить("Организация", Объект.Организация);
	ПараметрыПодбора.Вставить("Контрагент", Объект.Контрагент);
	ПараметрыПодбора.Вставить("НаправлениеДеятельности", Объект.НаправлениеДеятельности);
	ПараметрыПодбора.Вставить("ВозвратОтРозничногоПокупателя", Ложь);
	ПараметрыПодбора.Вставить("ЧекККМ", ПредопределенноеЗначение("Документ.ЧекККМ.ПустаяСсылка"));
	ПараметрыПодбора.Вставить("ПоказыватьТовары",Истина);
	ПараметрыПодбора.Вставить("ПоказыватьТару",Ложь);
	
	ОткрытьФорму("ОбщаяФорма.ПодборТоваровПоРеализациямИПередачам", ПараметрыПодбора, ЭтаФорма);
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	НоменклатураСервер.УстановитьУсловноеОформлениеХарактеристикНоменклатуры(ЭтаФорма, 
																			 "ВозвращаемыеТоварыХарактеристика",
																		     "Объект.ВозвращаемыеТовары.ХарактеристикиИспользуются");

	//

	НоменклатураСервер.УстановитьУсловноеОформлениеСерийНоменклатуры(ЭтаФорма, Ложь, 
																     "ВозвращаемыеТоварыСерия", 
																     "Объект.ВозвращаемыеТовары.СтатусУказанияСерий",
																	 "Объект.ВозвращаемыеТовары.ТипНоменклатуры");

	//

	НоменклатураСервер.УстановитьУсловноеОформлениеСтатусовУказанияСерий(ЭтаФорма, Ложь, 
																		 "ВозвращаемыеТоварыСтатусУказанияСерий",
                                                                         "Объект.ВозвращаемыеТовары.СтатусУказанияСерий");

КонецПроцедуры

#Область ПриИзмененииРеквизитовНаСервере

&НаСервере
Процедура СоглашениеПриИзмененииСервер(РезультатВыбора)

	Объект.Валюта                 = РезультатВыбора.Валюта;
	Объект.Организация            = РезультатВыбора.Организация;
	ХозяйственнаяОперацияДоговора = РезультатВыбора.ХозяйственнаяОперация;
	Объект.ХозяйственнаяОперация  = ПродажиСервер.ПолучитьХозяйственнуюОперациюВозвратаПоРеализации(РезультатВыбора.ХозяйственнаяОперация);
	Объект.ЦенаВключаетНДС        = РезультатВыбора.ЦенаВключаетНДС;

	ЗаполнитьНалогообложениеНДСПродажи();
	
	УправлениеДоступностьюИзменениеСоглашения(РезультатВыбора);

	РассчитатьИтоговыеПоказателиЗаявкиНаВозврат(ЭтаФорма);
	ТекущееЗначениеКонтрагента = Объект.Контрагент;
	ВариантыОбеспечения = ПродажиСервер.ВариантОбеспеченияИФлагОбособленноПоУмолчанию(
		Объект.Соглашение,
		Объект.Статус,
		,
		Не Объект.ЭтоЗаказКакСчет);
	
КонецПроцедуры

&НаСервере
Процедура КонтрагентПриИзмененииСервер()
	
	СамообслуживаниеСервер.УправлениеЭлементомФормыДоговор(Объект, Элементы.Договор,
	                                                       ИспользуютсяДоговорыКонтрагентов, ХозяйственнаяОперацияДоговора);
	
КонецПроцедуры

&НаКлиенте
Процедура ДоговорПриИзменении(Элемент)
	
	ДоговорПриИзмененииСервер();
	
КонецПроцедуры

#КонецОбласти

#Область УправлениеДоступностьюРеквизитовФормы

&НаСервере
Процедура УправлениеДоступностьюИзменениеСоглашения(Данные)
	
	СамообслуживаниеСервер.СформироватьТекстовыеПредставленияПолейФормыДокумента(ЭтаФорма);
	
	Если Данные = Неопределено Тогда
		ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Договор", "Доступность", Ложь);
		ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Контрагент", "Доступность", Ложь);
		ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ФормаОплаты", "Доступность", Ложь);
		Возврат;
	КонецЕсли;
	
	ИспользуютсяДоговорыКонтрагентов = Данные.ИспользуютсяДоговорыКонтрагентов;
	
	СамообслуживаниеСервер.УправлениеЭлементомФормыКонтрагент(Объект, Данные, Элементы.Контрагент);
	СамообслуживаниеСервер.УправлениеЭлементомФормыДоговор(Объект, Элементы.Договор,
	                                                       ИспользуютсяДоговорыКонтрагентов, ХозяйственнаяОперацияДоговора);
	СамообслуживаниеСервер.УправлениеЭлементомФормыСклад(Объект, Данные, Элементы.Склад);
	РассчитатьИтоговыеПоказателиЗаявкиНаВозврат(ЭтаФорма);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеДоступностью(Форма)

	Форма.Элементы.ВозвращаемыеТоварыПодобратьТоварыПоРеализациям.Доступность = ЗначениеЗаполнено(Форма.Объект.Соглашение)
	                                                                          И ЗначениеЗаполнено(Форма.Объект.Контрагент);
	
	Форма.Элементы.ВозвращаемыеТоварыОткрытьКарточкуТовара.Доступность = Форма.Объект.ВозвращаемыеТовары.Количество() > 0;

КонецПроцедуры

#КонецОбласти

#Область ФормированиеИВыводИнформацииНаФорму

&НаКлиентеНаСервереБезКонтекста
Процедура РассчитатьИтоговыеПоказателиЗаявкиНаВозврат(Форма)
	
	КоллекцияВозвращаемыеТовары = Форма.Объект.ВозвращаемыеТовары;
	
	Форма.СуммаНДСВозвращаемыхТоваров = КоллекцияВозвращаемыеТовары.Итог("СуммаНДС");
	Форма.СуммаВозвращаемыхТоваров = КоллекцияВозвращаемыеТовары.Итог("СуммаСНДС");
	
	ОтображатьИтогСуммыНДС = УчетНДСУПКлиентСервер.ОтображатьНДСВИтогахДокументаПродажи(Форма.Объект.НалогообложениеНДС);

	Если ОтображатьИтогСуммыНДС Тогда
		
		Форма.Элементы.ГруппаСтраницыНДСВозвращаемыеТовары.ТекущаяСтраница   = Форма.Элементы.СтраницаСНДСВозвращаемыеТовары;
		Форма.Элементы.ГруппаСтраницыВсегоВозвращаемыеТовары.ТекущаяСтраница = Форма.Элементы.СтраницаВсегоСНДСВозвращаемыеТовары;
		
	Иначе
		
		Форма.Элементы.ГруппаСтраницыНДСВозвращаемыеТовары.ТекущаяСтраница   = Форма.Элементы.СтраницаБезНДСВозвращаемыеТовары;
		Форма.Элементы.ГруппаСтраницыВсегоВозвращаемыеТовары.ТекущаяСтраница = Форма.Элементы.СтраницаВсегоБезНДСВозвращаемыеТовары;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьИнформациюПоРеализациям()
	
	ПродажиСервер.ОбновитьИнформациюПоРеализациямВФорме(
		СписокРеализаций,
		Объект.ДокументРеализации,
		НадписьЗаголовокРеализации,
		Элементы,
		Элементы.ВозвращаемыеТоварыДокументРеализации,
		Объект.ВозвращаемыеТовары,
		"ДокументРеализации");
	
КонецПроцедуры

&НаСервере
Процедура УстановитьЗаголовокДокумента(ЭтоНовыйОбъект)
	
	Если ЭтоНовыйОбъект Тогда
		
		Заголовок = НСтр("ru = 'Заявка на возврат (создание)'");
		
	Иначе
		
		Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Заявка на возврат %1 от %2'"),
		                                                                    Объект.Номер, Объект.Дата);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Серии

&НаСервере
Процедура УстановитьВидимостьЭлементовСерий()
	
	Элементы.ВозвращаемыеТоварыСтатусУказанияСерий.Видимость = ПараметрыУказанияСерий.Возвращаемые.ИспользоватьСерииНоменклатуры;
	Элементы.ВозвращаемыеТоварыУказатьСерии.Видимость        = ПараметрыУказанияСерий.Возвращаемые.ИспользоватьСерииНоменклатуры;
	
КонецПроцедуры

&НаСервере
Процедура ПодготовитьЗаполнитьУстановитьВидимостьСерий()
	
	ПараметрыУказанияСерий = Новый ФиксированнаяСтруктура(НоменклатураСервер.ПараметрыУказанияСерий(Объект, Документы.ЗаявкаНаВозвратТоваровОтКлиента));
	
	НоменклатураСервер.ЗаполнитьСтатусыУказанияСерий(Объект,ПараметрыУказанияСерий.Возвращаемые);
	
	УстановитьВидимостьЭлементовСерий();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПодборСерий(Текст = "")
	Если НоменклатураКлиент.ДляУказанияСерийНуженСерверныйВызов(ЭтаФорма,ПараметрыУказанияСерий.Возвращаемые,Текст) Тогда
		ТекущиеДанныеИдентификатор = Элементы.ВозвращаемыеТовары.ТекущиеДанные.ПолучитьИдентификатор();
		ПараметрыФормыУказанияСерий = ПараметрыФормыУказанияСерий(ТекущиеДанныеИдентификатор);
		
		ЗначениеВозврата = Неопределено;

		
		ОткрытьФорму(ПараметрыФормыУказанияСерий.ИмяФормы,ПараметрыФормыУказанияСерий,ЭтаФорма,,,, Новый ОписаниеОповещения("ОткрытьПодборСерийЗавершение", ЭтотОбъект, Новый Структура("ПараметрыФормыУказанияСерий", ПараметрыФормыУказанияСерий)), РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПодборСерийЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    ПараметрыФормыУказанияСерий = ДополнительныеПараметры.ПараметрыФормыУказанияСерий;
    
    
    ЗначениеВозврата = Результат;
    
    Если ЗначениеВозврата <> Неопределено Тогда
        ОбработатьУказаниеСерийСервер(ПараметрыФормыУказанияСерий);
    КонецЕсли;

КонецПроцедуры

&НаСервере
Функция ПараметрыФормыУказанияСерий(ТекущиеДанныеИдентификатор)
	
	Возврат НоменклатураСервер.ПараметрыФормыУказанияСерий(Объект, ПараметрыУказанияСерий.Возвращаемые, ТекущиеДанныеИдентификатор, ЭтаФорма);
	
КонецФункции

&НаСервере
Процедура ОбработатьУказаниеСерийСервер(ПараметрыФормыУказанияСерий)
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ОбновлятьКоличествоТоваровПриРегистрацииСерий", Истина);
	ДобавитьВСтруктуруДействияПриИзмененииКоличестваУпаковокВозвращаемыеТовары(СтруктураДействий, Объект);
	
	НоменклатураСервер.ОбработатьУказаниеСерий(Объект,ПараметрыУказанияСерий.Возвращаемые,ПараметрыФормыУказанияСерий,СтруктураДействий);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСтатусыУказанияСерийПриОкончанииРедактированияСтрокиТЧ(ТекущаяСтрокаИдентификатор, КэшированныеЗначения, ИмяТЧ)
	
	НоменклатураСервер.ЗаполнитьСтатусыУказанияСерийПриОкончанииРедактированияСтрокиТЧ(Объект,
		ПараметрыУказанияСерий.Возвращаемые, ТекущаяСтрокаИдентификатор, КэшированныеЗначения);
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаКлиенте
Процедура ОткрытьКарточкуНоменклатуры()

	ТекущиеДанные = Элементы.ВозвращаемыеТовары.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда
		ПараметрыФормы = Новый Структура("Ключ", ТекущиеДанные.Номенклатура);
		ОткрытьФорму("Справочник.Номенклатура.Форма.ФормаЭлемента", ПараметрыФормы);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	Если Не Объект.Соглашение.Пустая() Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = "
		|ВЫБРАТЬ
		|	СоглашенияСКлиентами.ИспользуютсяДоговорыКонтрагентов,
		|	СоглашенияСКлиентами.Склад,
		|	СоглашенияСКлиентами.ФормаОплаты,
		|	СоглашенияСКлиентами.Контрагент,
		|	&Партнер,
		|	ЕСТЬNULL(Склады.ЭтоГруппа, ЛОЖЬ) КАК ЭтоГруппаСкладов,
		|	СоглашенияСКлиентами.ПорядокРасчетов,
		|	СоглашенияСКлиентами.СегментНоменклатуры
		|ИЗ
		|	Справочник.СоглашенияСКлиентами КАК СоглашенияСКлиентами
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Склады КАК Склады
		|		ПО СоглашенияСКлиентами.Склад = Склады.Ссылка
		|ГДЕ
		|	СоглашенияСКлиентами.Ссылка = &Соглашение";
		
		Запрос.УстановитьПараметр("Соглашение", Объект.Соглашение);
		Запрос.УстановитьПараметр("Партнер", Объект.Партнер);
		
		Выборка = Запрос.Выполнить().Выбрать();
		Выборка.Следующий();
		
		ХозяйственнаяОперацияДоговора = СамообслуживаниеКлиентСервер.ХозяйственнаяОперацияДоговора(Объект.ХозяйственнаяОперация);
		
	Иначе
		
		Выборка = СамообслуживаниеСервер.ПолучитьСоглашениеПартнераПоУмолчанию(
		                         Объект.Партнер,
		                         Перечисления.ХозяйственныеОперации.ПустаяСсылка());
		Если Выборка <> Неопределено Тогда
			Объект.Соглашение = Выборка.Ссылка;
			СоглашениеПриИзмененииСервер(Выборка);
		КонецЕсли;
		
	КонецЕсли;
	
	УправлениеДоступностьюИзменениеСоглашения(Выборка);
	
	ВалютаДокумента = Объект.Валюта;
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ЗаполнитьПризнакХарактеристикиИспользуются", Новый Структура("Номенклатура", "ХарактеристикиИспользуются"));
	СтруктураДействий.Вставить("ЗаполнитьПризнакТипНоменклатуры", Новый Структура("Номенклатура", "ТипНоменклатуры"));
	СтруктураДействий.Вставить("ЗаполнитьПризнакАртикул", Новый Структура("Номенклатура", "Артикул"));
	
	ПараметрыУказанияСерий = Новый ФиксированнаяСтруктура(НоменклатураСервер.ПараметрыУказанияСерий(Объект, Документы.ЗаявкаНаВозвратТоваровОтКлиента));
	УстановитьВидимостьЭлементовСерий();
	НоменклатураСервер.ЗаполнитьСлужебныеРеквизитыПоНоменклатуреВКоллекции(Объект.ВозвращаемыеТовары, СтруктураДействий);

	ОбновитьИнформациюПоРеализациям();
	РассчитатьИтоговыеПоказателиЗаявкиНаВозврат(ЭтаФорма);
	УправлениеДоступностью(ЭтаФорма);
	ТекущееЗначениеКонтрагента = Объект.Контрагент;
	ВариантыОбеспечения = ПродажиСервер.ВариантОбеспеченияИФлагОбособленноПоУмолчанию(
		Объект.Соглашение,
		Объект.Статус,
		,
		Не Объект.ЭтоЗаказКакСчет);

КонецПроцедуры

&НаСервере
Процедура ОбработкаВыбораПодборПоРеализацииСервер(ВыбранноеЗначение)
	
	СтруктураВозвращаемыхЗначений = ПолучитьИзВременногоХранилища(ВыбранноеЗначение.АдресТоваровВХранилище);
	ТаблицаТоваров = СтруктураВозвращаемыхЗначений.Товары;
	СтруктураШапки = СтруктураВозвращаемыхЗначений.СтруктураШапки;
	
	КоличествоТоваровПервоначально = Объект.ВозвращаемыеТовары.Количество();
	
	Для каждого СтрокаТовара Из ТаблицаТоваров Цикл
		
		ТекущаяСтрока = Объект.ВозвращаемыеТовары.Добавить();
		ЗаполнитьЗначенияСвойств(ТекущаяСтрока, СтрокаТовара);
		ТекущаяСтрока.Цена = ТекущаяСтрока.Сумма / ТекущаяСтрока.КоличествоУпаковок;
		
	КонецЦикла;
	
	СтруктураДействий = Новый Структура;
	
	СтруктураДействий.Вставить("ЗаполнитьПризнакХарактеристикиИспользуются", Новый Структура("Номенклатура", "ХарактеристикиИспользуются"));
	СтруктураДействий.Вставить("ЗаполнитьПризнакТипНоменклатуры", Новый Структура("Номенклатура", "ТипНоменклатуры"));
	СтруктураДействий.Вставить("ЗаполнитьПризнакАртикул", Новый Структура("Номенклатура", "Артикул"));
	
	ПараметрыУказанияСерий = Новый ФиксированнаяСтруктура(НоменклатураСервер.ПараметрыУказанияСерий(Объект, Документы.ЗаявкаНаВозвратТоваровОтКлиента));
	НоменклатураСервер.ЗаполнитьСлужебныеРеквизитыПоНоменклатуреВКоллекции(Объект.ВозвращаемыеТовары, СтруктураДействий);
	НоменклатураСервер.ЗаполнитьСтатусыУказанияСерий(Объект,ПараметрыУказанияСерий.Возвращаемые);
	
	ОбновитьИнформациюПоРеализациям();
	РассчитатьИтоговыеПоказателиЗаявкиНаВозврат(ЭтаФорма);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ДобавитьВСтруктуруДействияПриИзмененииКоличестваУпаковокВозвращаемыеТовары(СтруктураДействий, Объект)
	
	СамообслуживаниеКлиентСервер.ДобавитьВСтруктуруДействияПриИзмененииКоличестваУпаковокВозвращаемыеТоварыОбщее(СтруктураДействий, Объект);
	
КонецПроцедуры

&НаСервере
Процедура ДоговорПриИзмененииСервер()
	
	ЗаполнитьНалогообложениеНДСПродажи();
	
	СтруктураПересчетаСуммы = ОбработкаТабличнойЧастиКлиентСервер.ПараметрыПересчетаСуммыНДСВТЧ(Объект);
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ЗаполнитьСтавкуНДС", ОбработкаТабличнойЧастиКлиентСервер.ПараметрыЗаполненияСтавкиНДС(Объект));
	СтруктураДействий.Вставить("ПересчитатьСуммуНДС", СтруктураПересчетаСуммы);
	СтруктураДействий.Вставить("ПересчитатьСуммуСНДС", СтруктураПересчетаСуммы);
	ОбработкаТабличнойЧастиСервер.ОбработатьТЧ(Объект.ВозвращаемыеТовары, СтруктураДействий, Неопределено);
	РассчитатьИтоговыеПоказателиЗаявкиНаВозврат(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура СкладПриИзмененииСервер()
	
	ЗаполнитьНалогообложениеНДСПродажи();
	
	СтруктураПересчетаСуммы = ОбработкаТабличнойЧастиКлиентСервер.ПараметрыПересчетаСуммыНДСВТЧ(Объект);
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ЗаполнитьСтавкуНДС", ОбработкаТабличнойЧастиКлиентСервер.ПараметрыЗаполненияСтавкиНДС(Объект));
	СтруктураДействий.Вставить("ПересчитатьСуммуНДС", СтруктураПересчетаСуммы);
	СтруктураДействий.Вставить("ПересчитатьСуммуСНДС", СтруктураПересчетаСуммы);
	ОбработкаТабличнойЧастиСервер.ОбработатьТЧ(Объект.ВозвращаемыеТовары, СтруктураДействий, Неопределено);
	
	ПодготовитьЗаполнитьУстановитьВидимостьСерий();

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНалогообложениеНДСПродажи()
	
	ПараметрыЗаполнения = Документы.ЗаявкаНаВозвратТоваровОтКлиента.ПараметрыЗаполненияНалогообложенияНДСПродажи(Объект);
	УчетНДСУП.ЗаполнитьНалогообложениеНДСПродажи(Объект.НалогообложениеНДС, ПараметрыЗаполнения, УчетНДСКэшированныеЗначенияПараметров);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
