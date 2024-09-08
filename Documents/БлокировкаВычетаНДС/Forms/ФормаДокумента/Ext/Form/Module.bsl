﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	
	// Обработчик механизма "ВерсионированиеОбъектов"
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом

	ОписаниеТиповСчетФактура = Метаданные.Документы.БлокировкаВычетаНДС.ТабличныеЧасти.СчетаФактуры.Реквизиты.СчетФактура.Тип;
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	СобытияФормКлиент.ПередЗаписью(ЭтотОбъект, Отказ, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)

	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)

	Оповестить("Запись_БлокировкаВычетаНДС", ПараметрыЗаписи, Объект.Ссылка);
	
	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);

	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
		МодульПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// Обработчик механизма "ДатыЗапретаИзменения"
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСчетаФактуры

&НаКлиенте
Процедура СчетаФактурыСчетФактураНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
		
	ТекущиеДанные = Элементы.СчетаФактуры.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ДоступныеТипы", ОписаниеТиповСчетФактура);
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ОбработкаВыборТипаСчетаФактуры", ЭтотОбъект);
		ОткрытьФорму("ОбщаяФорма.ВыборТипаИзСписка", ПараметрыФормы, ЭтаФорма, , , , ОписаниеОповещения);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры


&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры


&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры
// Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Записать(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	ОбщегоНазначенияУТКлиент.ЗаписатьИЗакрыть(ЭтаФорма);
	
КонецПроцедуры
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбработкаВыборТипаСчетаФактуры(Результат, Контрагент) Экспорт
	
	ПараметрыФормы = ПараметрыОткрытияФормыВыбораСчетаФактуры(Результат, Контрагент);
	
	Если ПараметрыФормы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОбработкаВыбораСчетФактура", ЭтотОбъект, );
	ОткрытьФорму(
		ПараметрыФормы.ИмяФормыВыбора, 
		ПараметрыФормы.ПараметрыОткрытия, 
		ЭтаФорма, 
		, 
		, 
		, 
		ОписаниеОповещения,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца); 
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбораСчетФактура(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда 
		Элементы.СчетаФактуры.ТекущиеДанные.СчетФактура = Результат;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПараметрыОткрытияФормыВыбораСчетаФактуры(ТипЗначения, Контрагент)
	
	Если ТипЗначения = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ИмяФормыВыбора = Метаданные.НайтиПоТипу(ТипЗначения).ПолноеИмя() + ".ФормаВыбора";
	
	Результат = Новый Структура;
	Результат.Вставить("ИмяФормыВыбора", ИмяФормыВыбора);
	
	ДанныеОбъекта = Новый Соответствие;
	ДанныеОбъекта.Вставить("Контрагент", Контрагент);
	ДанныеОбъекта.Вставить("Организация", Объект.Организация);
	
	Отбор = Новый Структура;
	Для каждого Параметр Из СвязиПараметрыОтбора(ТипЗначения) Цикл
		Если ЗначениеЗаполнено(ДанныеОбъекта[Параметр.Значение]) Тогда
			Отбор.Вставить(Параметр.Ключ, ДанныеОбъекта[Параметр.Значение]);
		КонецЕсли;
	КонецЦикла;
	
	Результат.Вставить("ПараметрыОткрытия", Новый Структура("Отбор", Отбор));
	
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Функция СвязиПараметрыОтбора(ТипЗначения)
	
	СвязиПараметрыОтбора = Новый Структура;
	Если ТипЗначения = Тип("ДокументСсылка.ПередачаТоваровМеждуОрганизациями") Тогда
		СвязиПараметрыОтбора.Вставить("ОрганизацияПолучатель", "Организация");
	ИначеЕсли ТипЗначения = Тип("ДокументСсылка.ВозвратТоваровМеждуОрганизациями") Тогда
		СвязиПараметрыОтбора.Вставить("ОрганизацияПолучатель", "Организация");
	Иначе
		СвязиПараметрыОтбора.Вставить("Организация", "Организация");
	КонецЕсли;
		
	Возврат СвязиПараметрыОтбора;
	
КонецФункции

#КонецОбласти