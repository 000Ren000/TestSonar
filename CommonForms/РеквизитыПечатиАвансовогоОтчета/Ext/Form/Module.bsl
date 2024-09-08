﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Параметры.ЗакрыватьПриВыборе            = Истина;
	Параметры.ЗакрыватьПриЗакрытииВладельца = Истина;
	
	Если Параметры.Свойство("ИмяДокумента")
		И Параметры.ИмяДокумента = "ПриобретениеТоваровУслуг" Тогда
		ЭтаФорма.ТолькоПросмотр = Не ПравоДоступа("Изменение", Метаданные.Документы.ПриобретениеТоваровУслуг);
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ЭтаФорма, Параметры.ДанныеПечати);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Модифицированность И Не Готово Тогда
		
		Отказ = Истина;
		
		СписокКнопок = Новый СписокЗначений();
		СписокКнопок.Добавить("Закрыть", НСтр("ru = 'Закрыть'"));
		СписокКнопок.Добавить("НеЗакрывать", НСтр("ru = 'Не закрывать'"));
		
		ПоказатьВопрос(
			Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект), 
			НСтр("ru = 'Все измененные данные будут потеряны. Закрыть форму?'"), 
			СписокКнопок);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = "Закрыть" Тогда
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	ОчиститьСообщения();
	
	Если Не Модифицированность Или ТолькоПросмотр Тогда
		
		Закрыть();
		
	Иначе
		СтруктураОбъекта = Новый Структура;
		СтруктураОбъекта.Вставить("НазначениеАванса",             НазначениеАванса);
		СтруктураОбъекта.Вставить("КоличествоДокументов",         КоличествоДокументов);
		СтруктураОбъекта.Вставить("КоличествоЛистов",             КоличествоЛистов);
		СтруктураОбъекта.Вставить("Руководитель",                 Руководитель);
		СтруктураОбъекта.Вставить("ГлавныйБухгалтер",             ГлавныйБухгалтер);
		
		Готово = Истина;
		
		ОповеститьОВыборе(СтруктураОбъекта);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти