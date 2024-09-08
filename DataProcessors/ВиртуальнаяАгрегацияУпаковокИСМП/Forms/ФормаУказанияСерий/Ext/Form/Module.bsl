﻿#Область ОписаниеПеременных

&НаКлиенте
Перем КэшированныеЗначения Экспорт;

&НаКлиенте
Перем Ссылка Экспорт;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ПараметрыУказанияСерий = Параметры.ПараметрыУказанияСерий;
	Склад = Параметры.Склад;
	
	Для Каждого Строка Из Параметры.СоставУпаковки Цикл
		НоваяСтрока = СоставУпаковки.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
	КонецЦикла;
	
	ПроверкаИПодборПродукцииИСМПКлиентСервер.ПересчитатьНомераСтрок(СоставУпаковки);
	ИнтеграцияИСПереопределяемый.ЗаполнитьСлужебныеРеквизитыВКоллекции(ЭтотОбъект, СоставУпаковки);
	ИнтеграцияИСПереопределяемый.ЗаполнитьСтатусыУказанияСерий(ЭтотОбъект, ПараметрыУказанияСерий);
	
	ОбщегоНазначенияСобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	СобытияФормИСМПКлиентПереопределяемый.ОбработкаВыбораСерии(ЭтотОбъект,
		ВыбранноеЗначение, ИсточникВыбора, ПараметрыУказанияСерий);
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТовары

&НаКлиенте
Процедура СоставУпаковкиСерияПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.СоставУпаковки.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СобытияФормИСМПКлиентПереопределяемый.ПриИзмененииСерии(ЭтотОбъект,
		ТекущиеДанные, КэшированныеЗначения, ПараметрыУказанияСерий);
	
КонецПроцедуры

&НаКлиенте
Процедура СоставУпаковкиСерияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.СоставУпаковки.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ИнтеграцияИСКлиент.ОткрытьПодборСерий(ЭтотОбъект,
		ПараметрыУказанияСерий, Элемент.ТекстРедактирования, СтандартнаяОбработка, ТекущиеДанные);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Готово(Команда)
	
	Результат = Новый Соответствие;
	Для Каждого Строка Из СоставУпаковки Цикл
		Результат.Вставить(Строка.Номенклатура, Строка.Серия);
	КонецЦикла;
	
	Закрыть(Результат);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	СобытияФормИСПереопределяемый.УстановитьУсловноеОформлениеСерийНоменклатуры(
		ЭтотОбъект,
		"СоставУпаковкиСерия",
		"СоставУпаковки.СтатусУказанияСерий",
		"СоставУпаковки.ТипНоменклатуры");
	
КонецПроцедуры

#КонецОбласти
