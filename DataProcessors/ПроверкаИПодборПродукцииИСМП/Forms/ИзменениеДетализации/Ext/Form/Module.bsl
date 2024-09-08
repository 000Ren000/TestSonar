﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(Параметры.ПроверяемыйДокумент) = Тип("ДокументСсылка.МаркировкаТоваровИСМП") Тогда
		Элементы.ДетализацияСтруктурыХраненияКоробки.Доступность                            = Ложь;
		Элементы.ДетализацияСтруктурыХраненияКоробаСГрупповымиУпаковками.Доступность        = Ложь;
		Элементы.ДетализацияСтруктурыХраненияГрупповыеУпаковкиСПотребительскими.Доступность = Ложь;
		Элементы.ДетализацияСтруктурыХраненияПотребительскиеУпаковки.Доступность            = Ложь;
	КонецЕсли;
	
	ЭлементыНеРекомендуемыеДетализации = Новый Массив;
	Если Параметры.РекомендуемаяДетализация = ПредопределенноеЗначение("Перечисление.ДетализацияСтруктурыХраненияИС.ПалетыСМонотоварнымиКоробами") Тогда
		ЭлементыНеРекомендуемыеДетализации.Добавить(Элементы.ДетализацияСтруктурыХраненияКоробаСГрупповымиУпаковками);
		ЭлементыНеРекомендуемыеДетализации.Добавить(Элементы.ДетализацияСтруктурыХраненияПолная);
		ЭлементыНеРекомендуемыеДетализации.Добавить(Элементы.ДетализацияСтруктурыХраненияГрупповыеУпаковкиСПотребительскими);
		ЭлементыНеРекомендуемыеДетализации.Добавить(Элементы.ДетализацияСтруктурыХраненияПотребительскиеУпаковки);
	ИначеЕсли Параметры.РекомендуемаяДетализация = ПредопределенноеЗначение("Перечисление.ДетализацияСтруктурыХраненияИС.КоробаСГрупповымиУпаковками") Тогда
		ЭлементыНеРекомендуемыеДетализации.Добавить(Элементы.ДетализацияСтруктурыХраненияПолная);
		ЭлементыНеРекомендуемыеДетализации.Добавить(Элементы.ДетализацияСтруктурыХраненияГрупповыеУпаковкиСПотребительскими);
		ЭлементыНеРекомендуемыеДетализации.Добавить(Элементы.ДетализацияСтруктурыХраненияПотребительскиеУпаковки);
	КонецЕсли;
	
	Для Каждого ЭлементФормы Из ЭлементыНеРекомендуемыеДетализации Цикл
		Для Каждого ЭлементСписка Из ЭлементФормы.СписокВыбора Цикл
			ЭлементСписка.Представление = СтрШаблон(НСтр("ru = '%1 (не рекомендуется)'"), ЭлементСписка.Представление);
		КонецЦикла;
		ЭлементФормы.ЦветТекста = ЦветаСтиля.ЦветТекстаПроблемаГосИС;
	КонецЦикла;
	
	Элементы.ГруппаОбщаяИнформация.Видимость = ЭлементыНеРекомендуемыеДетализации.Количество() > 0;
	
	ДетализацияСтруктурыХранения = Параметры.ДетализацияСтруктурыХранения;
	
	ОбщегоНазначенияСобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	Закрыть(ДетализацияСтруктурыХранения);
	
КонецПроцедуры

#КонецОбласти
