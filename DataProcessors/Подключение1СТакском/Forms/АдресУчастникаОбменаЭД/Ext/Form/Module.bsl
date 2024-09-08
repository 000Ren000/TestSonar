﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОписаниеПеременных

// Хранение контекста взаимодействия с сервисом
&НаКлиенте
Перем КонтекстВзаимодействия Экспорт;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	
	ТолькоПросмотр = (Параметры.ТолькоПросмотр = Истина);
	
	Индекс     = Параметры.Индекс;
	Регион     = Параметры.Регион;
	Район      = Параметры.Район;
	Город      = Параметры.Город;
	НасПункт   = Параметры.НасПункт;
	Улица      = Параметры.Улица;
	Дом        = Параметры.Дом;
	Корпус     = Параметры.Корпус;
	Квартира   = Параметры.Квартира;
	КодРегиона = Параметры.КодРегиона;
	
	Элементы.СсылкаЗагрузить.Видимость = НЕ ТолькоПросмотр;
	Элементы.ФормаОтмена.Видимость     = Элементы.СсылкаЗагрузить.Видимость;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Если Модифицированность И Не ПрограммноеЗакрытие Тогда
		
		Отказ = Истина;
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"ПриОтветеНаВопросОСохраненииИзмененныхДанных",
			ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Адрес участника обмена электронными документами изменен.
			|Сохранить изменения?'");
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СсылкаЗагрузитьНажатие(Элемент)
	
	// Передача команды на сервер
	ПараметрыЗапроса = Новый Массив;
	ПараметрыЗапроса.Добавить(Новый Структура("Имя, Значение", "getcodesregion", "true"));
	
	// Отправить параметры на сервер
	Подключение1СТакскомКлиент.ОбработкаКомандСервиса(
		КонтекстВзаимодействия,
		Неопределено,
		ПараметрыЗапроса);
	
КонецПроцедуры

&НаКлиенте
Процедура КодРегионаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	СписокКодовРегионов = Подключение1СТакскомКлиент.ЗначениеСессионногоПараметра(
		КонтекстВзаимодействия.КСКонтекст,
		"codesRegionED");
	
	Если СписокКодовРегионов = Неопределено Тогда
		
		ТекстПредупреждения = НСтр("ru = 'Список кодов еще не загружен. Нажмите на ссылку ""Загрузить"" или введите код региона вручную.'");
		ПоказатьПредупреждение(, ТекстПредупреждения);
		Возврат;
		
	КонецЕсли;
	
	ТекущийЭлементСписка = СписокКодовРегионов.НайтиПоЗначению(КодРегиона);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриВыбореКодаРегиона", ЭтотОбъект);
	
	СписокКодовРегионов.ПоказатьВыборЭлемента(
		ОписаниеОповещения,
		НСтр("ru = 'Коды регионов'"),
		ТекущийЭлементСписка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	
	Модифицированность = Ложь;
	
	Если ЭтотОбъект.ТолькоПросмотр Тогда
		Закрыть();
	Иначе
		// Возврат данных адреса
		Закрыть(ПодготовитьВозвращаемуюСтруктуру());
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Подготовка возвращаемой структуры с данными адреса.
// Возвращаемое значение: структура с полями - реквизитами адреса.
//
&НаКлиенте
Функция ПодготовитьВозвращаемуюСтруктуру()
	
	СтруктураОтвета = Новый Структура;
	СтруктураОтвета.Вставить("Индекс"          , Индекс);
	СтруктураОтвета.Вставить("Регион"          , Регион);
	СтруктураОтвета.Вставить("КодРегиона"      , КодРегиона);
	СтруктураОтвета.Вставить("Район"           , Район);
	СтруктураОтвета.Вставить("Город"           , Город);
	СтруктураОтвета.Вставить("НаселенныйПункт" , НасПункт);
	СтруктураОтвета.Вставить("Улица"           , Улица);
	СтруктураОтвета.Вставить("Дом"             , Дом);
	СтруктураОтвета.Вставить("Корпус"          , Корпус);
	СтруктураОтвета.Вставить("Квартира"        , Квартира);
	
	Возврат СтруктураОтвета;
	
КонецФункции

&НаКлиенте
Процедура ПриОтветеНаВопросОСохраненииИзмененныхДанных(РезультатВопроса, ДопПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		
		Модифицированность = Ложь;
		Закрыть(ПодготовитьВозвращаемуюСтруктуру());
		
	ИначеЕсли РезультатВопроса = КодВозвратаДиалога.Нет Тогда
		
		Модифицированность = Ложь;
		Закрыть();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриВыбореКодаРегиона(ВыбранныйЭлемент, ДопПараметры) Экспорт
	
	Если ВыбранныйЭлемент <> Неопределено Тогда
		
		КодРегиона = ВыбранныйЭлемент.Значение;
		Если ПустаяСтрока(Регион) Тогда
			Регион = Сред(ВыбранныйЭлемент.Представление, 6);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
