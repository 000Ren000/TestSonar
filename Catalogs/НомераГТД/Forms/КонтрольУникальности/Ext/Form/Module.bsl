﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Возврат при получении формы для анализа.
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ТаблицаНайдено.Загрузить(ПолучитьИзВременногоХранилища(Параметры.АдресВременногоХранилищаТаблицаНайдено));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыбратьСуществующую(Команда)
	
	ОчиститьСообщения();
	
	ТекущаяСтрока = Элементы.ТаблицаНайдено.ТекущиеДанные;
	
	Если ТекущаяСтрока = Неопределено Тогда
		ТекстСообщения = НСтр("ru = 'Номер РНПТ комплекта не выбрана'");
		
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, , "ТаблицаНайдено");
		
		Возврат;
	КонецЕсли;
	
	РезультатОбработки = НоменклатураКлиент.НовыйРезультатОбработкиЗавершения();
	РезультатОбработки.Действие	= "ВыбратьСуществующую";
	РезультатОбработки.Ссылка	= ТекущаяСтрока.Ссылка;
	
	Закрыть(РезультатОбработки);
	
КонецПроцедуры

&НаКлиенте
Процедура ПродолжитьЗаполнение(Команда)
	
	РезультатОбработки = НоменклатураКлиент.НовыйРезультатОбработкиЗавершения();
	РезультатОбработки.Действие = "ПродолжитьЗаполнение";
	
	Закрыть(РезультатОбработки);
	
КонецПроцедуры

#КонецОбласти