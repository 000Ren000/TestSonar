﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Объект.Ссылка.Пустая() Тогда
		ПриСозданииЧтенииНаСервере();
	КонецЕсли;
	
	ОбщегоНазначенияСобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ОбщегоНазначенияСобытияФормИСКлиентПереопределяемый.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриСозданииЧтенииНаСервере();
	
	ОбщегоНазначенияСобытияФормИСПереопределяемый.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	ШаблонСообщения = НСтр("ru = 'Не заполнена колонка ""%1"" в строке %2 списка ""Ответственные""'");
	
	Для Каждого Строка Из Объект.Ответственные Цикл
		
		НомерСтроки = Объект.Ответственные.Индекс(Строка) + 1;
		
		Если Не ЗначениеЗаполнено(Строка.Время) Тогда
			ТекстСообщения = СтрШаблон(
				ШаблонСообщения,
				НСтр("ru = 'Оповещать за'"),
				НомерСтроки);
			
			ОбщегоНазначения.СообщитьПользователю(
				ТекстСообщения,
				Объект.Ссылка,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти(
					"Объект.Ответственные", НомерСтроки, "Время"),,
				Отказ);
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Строка.ТипВремени) Тогда
			ТекстСообщения = СтрШаблон(
				ШаблонСообщения,
				НСтр("ru = 'ч. / мин.'"),
				НомерСтроки);
			
			ОбщегоНазначения.СообщитьПользователю(
				ТекстСообщения,
				Объект.Ссылка,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти(
					"Объект.Ответственные", НомерСтроки, "ТипВремени"),,
				Отказ);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Для Каждого Строка Из Объект.Ответственные Цикл
		
		Если Строка.ТипВремени = "час" Тогда
			Строка.ВремяВСекундах = Строка.Время * 3600;
		Иначе
			Строка.ВремяВСекундах = Строка.Время * 60;
		КонецЕсли;
		
	КонецЦикла;
	
	ОбщегоНазначенияСобытияФормИСКлиентПереопределяемый.ПередЗаписью(ЭтотОбъект, Отказ, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ОбновитьПредставленияНаФорме();
	
	ОбщегоНазначенияСобытияФормИСПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ТипТокенаАвторизацииПриИзменении(Элемент)
	
	УправлениеЭлементамиФормы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветственныеВремяПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Ответственные.ТекущиеДанные;
	
	Если ТекущиеДанные.Время < 10 Тогда
		ТекущиеДанные.ТипВремени = "час";
	ИначеЕсли ТекущиеДанные.Время >= 10 Тогда
		ТекущиеДанные.ТипВремени = "мин";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветственныеТипВремениПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Ответственные.ТекущиеДанные;
	
	Если ТекущиеДанные.Время >= 10 И ТекущиеДанные.ТипВремени = "час" Тогда
		ТекущиеДанные.Время = 9;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	Элементы.Организация.ПодсказкаВвода = НСтр("ru = '<для всех организаций>'");
	Элементы.ПроизводственныйОбъект.ПодсказкаВвода = НСтр("ru = '<для всех производственных объектов>'");
	
	СписокВыбора = Элементы.ОтветственныеТипВремени.СписокВыбора;
	СписокВыбора.Очистить();
	СписокВыбора.Добавить("час", НСтр("ru = 'ч.'"));
	СписокВыбора.Добавить("мин", НСтр("ru = 'мин.'"));
	
	УсловноеОформление.Элементы.Очистить();
	Для Каждого ЗначениеСписка Из СписокВыбора Цикл
		
		ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
		
		ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ОтветственныеТипВремени.Имя);
		
		ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных(Элементы.ОтветственныеТипВремени.ПутьКДанным);
		ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = ЗначениеСписка.Значение;
		
		ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Текст", ЗначениеСписка.Представление);
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииЧтенииНаСервере()
	
	Список = Элементы.ТипТокенаАвторизации.СписокВыбора;
	Список.Очистить();
	Список.Добавить(Перечисления.ТипыТокеновАвторизации.ПустаяСсылка(), НСтр("ru = 'Все'"));
	Список.Добавить(Перечисления.ТипыТокеновАвторизации.ИСМП);
	Список.Добавить(Перечисления.ТипыТокеновАвторизации.СУЗ);
	
	ОбновитьПредставленияНаФорме();
	
	УправлениеЭлементамиФормы(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьПредставленияНаФорме()
	
	Для Каждого Строка Из Объект.Ответственные Цикл
		
		Время = Цел(Строка.ВремяВСекундах / 3600);
		
		Если Время > 0 Тогда
			Строка.ТипВремени = "час";
		Иначе
			Время = Цел(Строка.ВремяВСекундах / 60);
			Строка.ТипВремени = "мин";
		КонецЕсли;
		
		Строка.Время = Время;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеЭлементамиФормы(Форма)
	
	Форма.Элементы.ПроизводственныйОбъект.Видимость = 
		Форма.Объект.ТипТокенаАвторизации <> ПредопределенноеЗначение("Перечисление.ТипыТокеновАвторизации.ИСМП");
	
КонецПроцедуры

#КонецОбласти
