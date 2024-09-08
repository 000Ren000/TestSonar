﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ТаблицаОборудования = Параметры.ТаблицаОборудования;
	
	Для Каждого СтрокаТаблицыОборудования Из ТаблицаОборудования Цикл
		СтрокаСписка = Список.Добавить();
		СтрокаСписка.Оборудование = СтрокаТаблицыОборудования.Оборудование;
		СтрокаСписка.ВерсияФФД = СтрокаТаблицыОборудования.ВерсияФФД;
		СтрокаСписка.Подключено = СтрокаТаблицыОборудования.Подключено;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура Выбрать(Команда)
	
	ОбработатьВыборККТ();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ОбработатьВыборККТ();
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть(Неопределено);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция ПредставлениеККТ(ОборудованиеККТ)
	
	Возврат ("" +  ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ОборудованиеККТ, "Наименование"));
	
КонецФункции

&НаКлиенте
Процедура ОбработатьВыборККТ()
	
	ОчиститьСообщения();
	
	ТекущаяСтрока = Элементы.Список.ТекущиеДанные;
	
	Если ТекущаяСтрока = Неопределено Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'ККТ не выбран'"));
		
		Возврат;
	КонецЕсли;
	
	Если НЕ ТекущаяСтрока.Подключено Тогда
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'ККТ ""%1"" не подключен'"),
			ПредставлениеККТ(ТекущаяСтрока.Оборудование));
		
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
		
		Возврат;
	КонецЕсли;
	
	СтруктураВыбранноеОборудованиеККТ = Новый Структура();
	СтруктураВыбранноеОборудованиеККТ.Вставить("Оборудование", ТекущаяСтрока.Оборудование);
	СтруктураВыбранноеОборудованиеККТ.Вставить("ВерсияФФД", ТекущаяСтрока.ВерсияФФД);
	
	Закрыть(СтруктураВыбранноеОборудованиеККТ);
	
КонецПроцедуры

#КонецОбласти