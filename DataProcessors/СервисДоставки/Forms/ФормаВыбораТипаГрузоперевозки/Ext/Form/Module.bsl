﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьСписокВыбораТипаГрузоперевозки(Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Элементы.ТипГрузоперевозки.СписокВыбора.Количество() = 1 Тогда
		
		ТипГрузоперевозки = Элементы.ТипГрузоперевозки.СписокВыбора[0].Значение;
		ПараметрыОповещения = Новый Структура();
		ПараметрыОповещения.Вставить("ТипГрузоперевозки", ТипГрузоперевозки);
		Закрыть(ПараметрыОповещения);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаВыбрать(Команда)
	
	ПараметрыОповещения = Новый Структура();
	ПараметрыОповещения.Вставить("ТипГрузоперевозки", ТипГрузоперевозки);
	Закрыть(ПараметрыОповещения);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьСписокВыбораТипаГрузоперевозки(Отказ)
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьСервис1СДоставка") = Истина Тогда
		Элементы.ТипГрузоперевозки.СписокВыбора.Добавить(1, СервисДоставкиКлиентСервер.ПредставлениеТипаГрузоперевозки(1));
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьСервис1СКурьер") = Истина Тогда
		Элементы.ТипГрузоперевозки.СписокВыбора.Добавить(2, СервисДоставкиКлиентСервер.ПредставлениеТипаГрузоперевозки(2));
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьСервис1СКурьерика") = Истина Тогда
		Элементы.ТипГрузоперевозки.СписокВыбора.Добавить(3, СервисДоставкиКлиентСервер.ПредставлениеТипаГрузоперевозки(3));
	КонецЕсли;
	
	Если Элементы.ТипГрузоперевозки.СписокВыбора.Количество() = 0 Тогда
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Нет доступных систем доставки'"),,,, Отказ);
	Иначе
		ТипГрузоперевозки = Элементы.ТипГрузоперевозки.СписокВыбора.Получить(0).Значение;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
