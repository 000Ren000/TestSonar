﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);

	ТолькоПросмотр = Не Параметры.Свойство("РучнаяНастройка");
	
	Инициализировать();
	УстановитьВидимость();
	
	// СтандартныеПодсистемы.БазоваяФункциональность
	МультиязычностьСервер.ПриСозданииНаСервере(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.БазоваяФункциональность
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)

	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	// СтандартныеПодсистемы.БазоваяФункциональность
	МультиязычностьСервер.ПередЗаписьюНаСервере(ТекущийОбъект);
	// Конец СтандартныеПодсистемы.БазоваяФункциональность
	
	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	// СтандартныеПодсистемы.БазоваяФункциональность
	МультиязычностьСервер.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.БазоваяФункциональность
	
	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	// СтандартныеПодсистемы.БазоваяФункциональность
	МультиязычностьСервер.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.БазоваяФункциональность
	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИсточникДанныхПриИзменении(Элемент)
	
	Объект.ПредставлениеИсточникаДанных = Элемент.ТекстРедактирования;
	ИсточникДанныхПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_Открытие(Элемент, СтандартнаяОбработка)
	// СтандартныеПодсистемы.БазоваяФункциональность
	МультиязычностьКлиент.ПриОткрытии(ЭтотОбъект, Объект, Элемент, СтандартнаяОбработка);
	// Конец СтандартныеПодсистемы.БазоваяФункциональность
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	Записать();
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаЗаписать(Команда)
	
	Записать();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ИсточникДанныхПриИзмененииНаСервере()
	
	Объект.ПоказателиРегистра.Очистить();
	
КонецПроцедуры

&НаСервере
Процедура Инициализировать()
	
	РодительДокументов = ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Документы");
	МассивПараметров = Новый Массив;
	МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Родитель", РодительДокументов));
	Элементы.ДокументыИдентификаторОбъектаМетаданных.ПараметрыВыбора = Новый ФиксированныйМассив(МассивПараметров);
	
	// Инициализируем список функциональных опций
	Для каждого ОписаниеОпции Из Метаданные.ФункциональныеОпции Цикл
		ТипОпции = ОписаниеОпции.Хранение.Тип.Типы();
		Если ТипОпции.Количество() = 1 И ТипОпции[0] = Тип("Булево") Тогда
			Элементы.ФункциональныеОпцииИмяФункциональнойОпции.СписокВыбора.Добавить(ОписаниеОпции.Имя, ОписаниеОпции.Синоним);
		КонецЕсли;
	КонецЦикла;
	
	// Инициализируем список источников данных
	СписокРегистров = ИсточникиДанныхПовтИсп.ДоступныеИсточникиДанных();
	Для Каждого Регистр Из СписокРегистров Цикл
		Элементы.ИсточникДанных.СписокВыбора.Добавить(Регистр.Значение,Регистр.Представление);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимость()
	
	Элементы.ФормаЗаписатьИЗакрыть.Видимость = НЕ ТолькоПросмотр;
	Элементы.ФормаЗаписать.Видимость = НЕ ТолькоПросмотр;
	Элементы.ФормаЗакрыть.Видимость = ТолькоПросмотр;
	
	Элементы.Документы.КоманднаяПанель.Видимость = НЕ ТолькоПросмотр;
	Элементы.ФункциональныеОпции.КоманднаяПанель.Видимость = НЕ ТолькоПросмотр;
	
КонецПроцедуры

#КонецОбласти
