﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ОтображатьЭтикеткуЛогистическойУпаковки   = Параметры.ОтображатьЭтикеткуЛогистическойУпаковки;
	ОтображатьЭтикеткуГрупповойУпаковки       = Параметры.ОтображатьЭтикеткуГрупповойУпаковки;
	ОтображатьЭтикеткуНабора                  = Параметры.ОтображатьЭтикеткуНабора;
	ОтображатьЭтикеткуПотребительскойУпаковки = Параметры.ОтображатьЭтикеткуПотребительскойУпаковки;
	ОтображатьКоличествоПечать                = Параметры.ОтображатьКоличествоПечать;
	
	НастроитьФорму(ЭтотОбъект);
	СтандартныеПодсистемыСервер.СброситьРазмерыИПоложениеОкна(ЭтотОбъект);
	
	СобытияФормИСМППереопределяемый.УстановитьПараметрыВыбораШаблонаЭтикетки(
		ЭтотОбъект,
		Элементы.ШаблонЭтикеткиЛогистическойУпаковки.Имя);
	
	СобытияФормИСМППереопределяемый.УстановитьПараметрыВыбораШаблонаЭтикетки(
		ЭтотОбъект,
		Элементы.ШаблонЭтикеткиГрупповойУпаковки.Имя);
	
	СобытияФормИСМППереопределяемый.УстановитьПараметрыВыбораШаблонаЭтикетки(
		ЭтотОбъект,
		Элементы.ШаблонЭтикеткиНабора.Имя);
	
	СобытияФормИСМППереопределяемый.УстановитьПараметрыВыбораШаблонаЭтикетки(
		ЭтотОбъект,
		Элементы.ШаблонЭтикеткиПотребительскойУпаковки.Имя);
	
	ОбщегоНазначенияСобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УправлениеЭлементамиФормы(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПриСохраненииДанныхВНастройкахНаСервере(Настройки)
	
	Настройки.Вставить("ШаблонЭтикеткиЛогистическойУпаковки",   ШаблонЭтикеткиЛогистическойУпаковки);
	Настройки.Вставить("ШаблонЭтикеткиГрупповойУпаковки",       ШаблонЭтикеткиГрупповойУпаковки);
	Настройки.Вставить("ШаблонЭтикеткиНабора",                  ШаблонЭтикеткиНабора);
	Настройки.Вставить("ШаблонЭтикеткиПотребительскойУпаковки", ШаблонЭтикеткиПотребительскойУпаковки);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	ШаблонЭтикеткиЛогистическойУпаковки   = Настройки.Получить("ШаблонЭтикеткиЛогистическойУпаковки");
	ШаблонЭтикеткиГрупповойУпаковки       = Настройки.Получить("ШаблонЭтикеткиГрупповойУпаковки");
	ШаблонЭтикеткиНабора                  = Настройки.Получить("ШаблонЭтикеткиНабора");
	ШаблонЭтикеткиПотребительскойУпаковки = Настройки.Получить("ШаблонЭтикеткиПотребительскойУпаковки");	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Заполнить(Команда)
	
	Закрыть(ПараметрыЗакрытияФормы());
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ЗаполнятьШаблонЛогистическойУпаковкиПриИзменении(Элемент)
	
	Если Не ЗаполнятьШаблонЭтикеткиЛогистическойУпаковки Тогда
		ШаблонЭтикеткиЛогистическойУпаковки = Неопределено;
	КонецЕсли;
	
	УправлениеЭлементамиФормы(ЭтаФорма);
	
КонецПроцедуры 

&НаКлиенте
Процедура ЗаполнятьШаблонЭтикеткиГрупповойУпаковкиПриИзменении(Элемент)
	
	Если Не ЗаполнятьШаблонЭтикеткиГрупповойУпаковки Тогда
		ШаблонЭтикеткиГрупповойУпаковки = Неопределено;
	КонецЕсли;
	
	УправлениеЭлементамиФормы(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнятьШаблонЭтикеткиНабораПриИзменении(Элемент)
	
	Если Не ЗаполнятьШаблонЭтикеткиНабора Тогда
		ШаблонЭтикеткиНабора = Неопределено;
	КонецЕсли;
	
	УправлениеЭлементамиФормы(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнятьШаблонПотребительскойУпаковкиПриИзменении(Элемент)
	
	Если Не ЗаполнятьШаблонЭтикеткиПотребительскойУпаковки Тогда
		ШаблонЭтикеткиПотребительскойУпаковки = Неопределено;
	КонецЕсли;
	
	УправлениеЭлементамиФормы(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнятьКоличествоПечатьПриИзменении(Элемент)
	
	УправлениеЭлементамиФормы(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнятьКоличествоЭкземпляровПриИзменении(Элемент)
	
	Если ЗаполнятьКоличествоЭкземпляров И КоличествоЭкземпляров = 0 Тогда
		КоличествоЭкземпляров = 1;
	КонецЕсли;
	
	УправлениеЭлементамиФормы(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура НастроитьФорму(Форма)
	
	Форма.Элементы.ГруппаЭтикеткаЛогистическойУпаковки.Видимость   = Форма.ОтображатьЭтикеткуЛогистическойУпаковки;
	Форма.Элементы.ГруппаЭтикеткаГрупповойУпаковки.Видимость       = Форма.ОтображатьЭтикеткуГрупповойУпаковки;
	Форма.Элементы.ГруппаЭтикеткаНабора.Видимость                  = Форма.ОтображатьЭтикеткуНабора;
	Форма.Элементы.ГруппаЭтикеткаПотребительскойУпаковки.Видимость = Форма.ОтображатьЭтикеткуПотребительскойУпаковки;
	Форма.Элементы.ГруппаКоличествоПечать.Видимость                = Форма.ОтображатьКоличествоПечать;
	Форма.Элементы.ГруппаКоличествоЭкземпляров.Видимость           = Форма.ОтображатьЭтикеткуЛогистическойУпаковки;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеЭлементамиФормы(Форма)
	
	Форма.Элементы.ШаблонЭтикеткиЛогистическойУпаковки.Доступность   = Форма.ЗаполнятьШаблонЭтикеткиЛогистическойУпаковки;
	Форма.Элементы.ШаблонЭтикеткиГрупповойУпаковки.Доступность       = Форма.ЗаполнятьШаблонЭтикеткиГрупповойУпаковки;
	Форма.Элементы.ШаблонЭтикеткиНабора.Доступность                  = Форма.ЗаполнятьШаблонЭтикеткиНабора;
	Форма.Элементы.ШаблонЭтикеткиПотребительскойУпаковки.Доступность = Форма.ЗаполнятьШаблонЭтикеткиПотребительскойУпаковки;
	Форма.Элементы.КоличествоЭкземпляров.Доступность                 = Форма.ЗаполнятьКоличествоЭкземпляров;
	Форма.Элементы.КоличествоПечать.Доступность                      = Форма.ЗаполнятьКоличествоПечать;
	
КонецПроцедуры

&НаКлиенте
Функция ПараметрыЗакрытияФормы()
	
	Результат = Новый Структура;
	
	Если ОтображатьЭтикеткуЛогистическойУпаковки
		И ЗаполнятьШаблонЭтикеткиЛогистическойУпаковки Тогда
		Результат.Вставить("ШаблонЭтикеткиЛогистическойУпаковки", ШаблонЭтикеткиЛогистическойУпаковки);
	КонецЕсли;
	
	Если ОтображатьЭтикеткуГрупповойУпаковки
		И ЗаполнятьШаблонЭтикеткиГрупповойУпаковки Тогда
		Результат.Вставить("ШаблонЭтикеткиГрупповойУпаковки", ШаблонЭтикеткиГрупповойУпаковки);
	КонецЕсли;
	
	Если ОтображатьЭтикеткуНабора
		И ЗаполнятьШаблонЭтикеткиНабора Тогда
		Результат.Вставить("ШаблонЭтикеткиНабора", ШаблонЭтикеткиНабора);
	КонецЕсли;
	
	Если ОтображатьЭтикеткуПотребительскойУпаковки
		И ЗаполнятьШаблонЭтикеткиПотребительскойУпаковки Тогда
		Результат.Вставить("ШаблонЭтикеткиПотребительскойУпаковки", ШаблонЭтикеткиПотребительскойУпаковки);
	КонецЕсли;
	
	Если ОтображатьКоличествоПечать
		И ЗаполнятьКоличествоПечать Тогда
		Результат.Вставить("КоличествоПечать", КоличествоПечать);
	КонецЕсли;
	
	Если ОтображатьЭтикеткуЛогистическойУпаковки
		И ЗаполнятьКоличествоЭкземпляров Тогда
		Результат.Вставить("КоличествоЭкземпляров", КоличествоЭкземпляров);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти