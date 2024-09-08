﻿#Область ОписаниеПеременных

&НаКлиенте
Перем КэшированныеЗначения; //используется механизмом обработки изменения реквизитов ТЧ

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);

	Если Параметры.Свойство("ДанныеЗаполнения") Тогда
		
		ДанныеЗаполнения = Параметры.ДанныеЗаполнения;
		ЗаполнитьЗначенияСвойств(Объект, ДанныеЗаполнения);
		
		Если ДанныеЗаполнения.Свойство("Номенклатура") Тогда
			НоваяСтрока = Объект.УменьшениеПотребностей.Добавить();
			НоваяСтрока.Номенклатура = ДанныеЗаполнения.Номенклатура;
			НоваяСтрока.Характеристика = ДанныеЗаполнения.Характеристика;
			НоваяСтрока.Назначение = ДанныеЗаполнения.Назначение;
			НоваяСтрока.Количество = ДанныеЗаполнения.Количество;
			НоваяСтрока.КоличествоУпаковок = ДанныеЗаполнения.Количество;
		КонецЕсли;
		
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		ПриЧтенииСозданииНаСервере();
		
	КонецЕсли;
	
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаКорректировкаПотребностей;
	
	УстановитьДоступностьКомандБуфераОбмена(ЭтаФорма, НЕ ОбщегоНазначения.ПустойБуферОбмена("Строки"));
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	//
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтаФорма, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства

	УстановитьПредставлениеДокументаОснования();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	// СтандартныеПодсистемы.РаботаСФайлами 	
	ПараметрыГиперссылки = РаботаСФайлами.ГиперссылкаФайлов(); 	
	ПараметрыГиперссылки.Размещение = "КоманднаяПанель"; 	
	РаботаСФайлами.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыГиперссылки); 	
	// Конец СтандартныеПодсистемы.РаботаСФайлами
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

	// СтандартныеПодсистемы.РаботаСФайлами
	РаботаСФайламиКлиент.ПриОткрытии(ЭтотОбъект, Отказ);
	// Конец СтандартныеПодсистемы.РаботаСФайлами
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ПриЧтенииСозданииНаСервере();
	
	// Обработчик механизма "ДатыЗапретаИзменения"
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "КопированиеСтрокВБуферОбмена" Тогда
		УстановитьДоступностьКомандБуфераОбмена(ЭтаФорма, Истина);
	КонецЕсли;
	
	// СтандартныеПодсистемы.Свойства 
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтаФорма, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства

	// СтандартныеПодсистемы.РаботаСФайлами
	РаботаСФайламиКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия);
	// Конец СтандартныеПодсистемы.РаботаСФайлами
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ЗаполнитьСлужебныеРеквизиты();
	
	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)

	Если Не Объект.РежимВВодаКорректировкиМногострочный
		И УправлениеПроцессомПланирования
		И ЗаполнятьПоДефициту Тогда 
		СтруктураКорректировки = Новый Структура();
		СтруктураКорректировки.Вставить("План", Объект.План);
		СтруктураКорректировки.Вставить("Сценарий", Объект.Сценарий);
		СтруктураКорректировки.Вставить("ВидПлана", Объект.ВидПлана);
		СтруктураКорректировки.Вставить("Период", Объект.Период);
		СтруктураКорректировки.Вставить("Номенклатура", Номенклатура);
		СтруктураКорректировки.Вставить("Характеристика", Характеристика);
		СтруктураКорректировки.Вставить("Назначение", Назначение);
		СтруктураКорректировки.Вставить("НоменклатураКорректировка", НоменклатураКорректировка);
		СтруктураКорректировки.Вставить("ХарактеристикаКорректировка", ХарактеристикаКорректировка);
		СтруктураКорректировки.Вставить("НазначениеКорректировка", НазначениеКорректировка);
		СтруктураКорректировки.Вставить("ККорректировке", ККорректировке);
		СтруктураКорректировки.Вставить("ККорректировкеКорректировка", ККорректировкеКорректировка);
		СтруктураКорректировки.Вставить("КОбеспечению", КОбеспечению);
		СтруктураКорректировки.Вставить("КОбеспечениюКорректировка", -КОбеспечениюКорректировка);
	
		Оповестить("Запись_КорректировкаПлановыхПотребностей", СтруктураКорректировки, Объект.Ссылка);
	КонецЕсли;
	
	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);

	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
		МодульПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если Не Объект.РежимВВодаКорректировкиМногострочный Тогда
		ЗаполнитьТЧКорректировкиПотребностей(ЭтаФорма, Объект);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
		
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);
	// Конец ИнтеграцияС1СДокументооборотом
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СценарийПриИзменении(Элемент)
	СценарийПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура СценарийПриИзмененииНаСервере()
	
	РеквизитыСценария = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.Сценарий, "ПланированиеПоНазначениям, УправлениеПроцессомПланирования");
	ПланированиеПоНазначениям = РеквизитыСценария.ПланированиеПоНазначениям;
	УправлениеПроцессомПланирования =  РеквизитыСценария.УправлениеПроцессомПланирования;
		
	УправлениеВидимостью(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеДокументаОснованияНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ЗначениеЗаполнено(Объект.План) Тогда
		
		ПоказатьЗначение(Неопределено, Объект.План);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РежимВводаКорректировкиПриИзменении(Элемент)
	Объект.РежимВВодаКорректировкиМногострочный = РежимВводаКорректировки;
	Если Объект.РежимВВодаКорректировкиМногострочный Тогда
		ЗаполнитьТЧКорректировкиПотребностей(ЭтаФорма, Объект);
	Иначе
		ЗаполнитьРеквизитыКорректировки(ЭтаФорма);
		ПотребностьПриИзмененииНаСервере();
		КорректировкаПриИзмененииНаСервере();
	КонецЕсли;
	УправлениеВидимостью(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура НоменклатураПриИзменении(Элемент)
	НоменклатураПриИзмененииСервер(КэшированныеЗначения);
	ПотребностьПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ХарактеристикаПриИзменении(Элемент)
	ПотребностьПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура НазначениеПриИзменении(Элемент)
	ПотребностьПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура НоменклатураКорректировкаПриИзменении(Элемент)
	НоменклатураПриИзмененииСервер(КэшированныеЗначения, Истина);
	КорректировкаПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ХарактеристикаКорректировкаПриИзменении(Элемент)
	КорректировкаПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура НазначениеКорректировкаПриИзменении(Элемент)
	КорректировкаПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура КЗаменеПриИзменении(Элемент)
	
	Если Не УправлениеПроцессомПланирования Тогда
		Возврат;
	КонецЕсли;
	
	КОбеспечению = Потребность - ККорректировке;
КонецПроцедуры

&НаКлиенте
Процедура ОбеспечитьПриИзменении(Элемент)
	
	ККорректировке = Потребность - КОбеспечению;
КонецПроцедуры

&НаКлиенте
Процедура ККорректировкеКорректировкаПриИзменении(Элемент)
	
	Если Не УправлениеПроцессомПланирования Тогда
		Возврат;
	КонецЕсли;
	
	КОбеспечениюКорректировка = Остаток - ККорректировкеКорректировка;
	
КонецПроцедуры

&НаКлиенте
Процедура КОбеспечениюКорректировкаПриИзменении(Элемент)
	
	ККорректировкеКорректировка = Остаток - КОбеспечениюКорректировка;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыУвеличениеПотребностей

&НаКлиенте
Процедура УвеличениеПотребностейНоменклатураПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.УвеличениеПотребностей.ТекущиеДанные;
	
	СтруктураДействий = Новый Структура;
	
	ДобавитьВСтруктуруДействияПриИзмененииНоменклатуры(СтруктураДействий, ТекущаяСтрока, "УвеличениеПотребностей");
	
	ДобавитьВСтруктуруДействияПриИзмененииКоличестваУпаковок(СтруктураДействий);
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура УвеличениеПотребностейКоличествоУпаковокПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.УвеличениеПотребностей.ТекущиеДанные;
	
	СтруктураДействий = Новый Структура;
	ДобавитьВСтруктуруДействияПриИзмененииКоличестваУпаковок(СтруктураДействий);
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущиеДанные, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура УвеличениеПотребностейУпаковкаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.УвеличениеПотребностей.ТекущиеДанные;
	
	СтруктураДействий = Новый Структура;
	ДобавитьВСтруктуруДействияПриИзмененииКоличестваУпаковок(СтруктураДействий);
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущиеДанные, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура УвеличениеПотребностей_ВставитьСтроки(Команда)
	
	ПолучитьСтрокиИзБуфераОбмена("УвеличениеПотребностей");
	
КонецПроцедуры

&НаКлиенте
Процедура УвеличениеПотребностей_СкопироватьСтроки(Команда)
	
	СкопироватьСтрокиТЧ("УвеличениеПотребностей");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыУменьшениеПотребностей

&НаКлиенте
Процедура УменьшениеПотребностейНоменклатураПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.УменьшениеПотребностей.ТекущиеДанные;
	
	СтруктураДействий = Новый Структура;
	
	ДобавитьВСтруктуруДействияПриИзмененииНоменклатуры(СтруктураДействий, ТекущаяСтрока, "УменьшениеПотребностей");
	
	ДобавитьВСтруктуруДействияПриИзмененииКоличестваУпаковок(СтруктураДействий);
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура УменьшениеПотребностейКоличествоУпаковокПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.УменьшениеПотребностей.ТекущиеДанные;
	
	СтруктураДействий = Новый Структура;
	ДобавитьВСтруктуруДействияПриИзмененииКоличестваУпаковок(СтруктураДействий);
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущиеДанные, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура УменьшениеПотребностейУпаковкаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.УменьшениеПотребностей.ТекущиеДанные;
	
	СтруктураДействий = Новый Структура;
	ДобавитьВСтруктуруДействияПриИзмененииКоличестваУпаковок(СтруктураДействий);
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущиеДанные, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура УменьшениеПотребностей_ВставитьСтроки(Команда)
	
	ПолучитьСтрокиИзБуфераОбмена("УменьшениеПотребностей");
	
КонецПроцедуры

&НаКлиенте
Процедура УменьшениеПотребностей_СкопироватьСтроки(Команда)
	
	СкопироватьСтрокиТЧ("УменьшениеПотребностей");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовСтраницыДополнительно

&НаКлиенте
Процедура КомментарийПриИзменении(Элемент)
	
	НастроитьЗависимыеЭлементыФормы(ЭтаФорма, "Комментарий");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры


&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры


// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура ЗаписатьДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Записать(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Провести(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиИЗакрыть(Команда)
	
	ОбщегоНазначенияУТКлиент.ПровестиИЗакрыть(ЭтаФорма);
	
КонецПроцедуры

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

// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура Перенести(Команда)
	ККорректировкеКорректировка = ККорректировке;
	
	Если Не УправлениеПроцессомПланирования Тогда
		Возврат;
	КонецЕсли;
	
	КОбеспечениюКорректировка = Остаток - ККорректировкеКорректировка;	
	КОбеспечению = Потребность - ККорректировке;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	#Область СтандартноеОформление
	НоменклатураСервер.УстановитьУсловноеОформлениеХарактеристикНоменклатуры(ЭтаФорма, 
																			 "УвеличениеПотребностейХарактеристика",
																		     "Объект.УвеличениеПотребностей.ХарактеристикиИспользуются");
	
	НоменклатураСервер.УстановитьУсловноеОформлениеЕдиницИзмерения(ЭтаФорма,
																   "УвеличениеПотребностейНоменклатураЕдиницаИзмерения",
																   "Объект.УвеличениеПотребностей.Упаковка");
																   
	#КонецОбласти
	
	#Область СтандартноеОформление
	НоменклатураСервер.УстановитьУсловноеОформлениеХарактеристикНоменклатуры(ЭтаФорма, 
																			 "УменьшениеПотребностейХарактеристика",
																		     "Объект.УменьшениеПотребностей.ХарактеристикиИспользуются");
	
	НоменклатураСервер.УстановитьУсловноеОформлениеЕдиницИзмерения(ЭтаФорма,
																   "УменьшениеПотребностейНоменклатураЕдиницаИзмерения",
																   "Объект.УменьшениеПотребностей.Упаковка");
																   
	#КонецОбласти
	
	//

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	РежимВводаКорректировки = Объект.РежимВВодаКорректировкиМногострочный;
	
	Если Не Объект.РежимВВодаКорректировкиМногострочный Тогда
		ЗаполнитьРеквизитыКорректировки(ЭтаФорма);
		
		НоменклатураПриИзмененииСервер(Неопределено);
		НоменклатураПриИзмененииСервер(Неопределено, Истина);
		
		ПотребностьПриИзмененииНаСервере();
		КорректировкаПриИзмененииНаСервере();
	КонецЕсли;
	
	РеквизитыСценария = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.Сценарий, "ПланированиеПоНазначениям, УправлениеПроцессомПланирования");
	ПланированиеПоНазначениям = РеквизитыСценария.ПланированиеПоНазначениям;
	УправлениеПроцессомПланирования =  РеквизитыСценария.УправлениеПроцессомПланирования;
	
	Если ЗначениеЗаполнено(Объект.План) Тогда
		УстановитьПривилегированныйРежим(Истина);
		ЗаполнятьПоДефициту = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.План, "ЗаполнятьПоДефициту");
		УстановитьПривилегированныйРежим(Ложь);
	Иначе
		ЗаполнятьПоДефициту = Ложь;
	КонецЕсли;
	
	ЗаполнитьСлужебныеРеквизиты();
	
	УправлениеВидимостью(ЭтаФорма);
	
	НастроитьЭлементыФормы();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПредставлениеДокументаОснования()
	
	ПредставлениеДокументаОснования = Объект.План;
	Элементы.ПредставлениеДокументаОснования.ЦветТекста = ЦветаСтиля.ГиперссылкаЦвет;
	
КонецПроцедуры

&НаСервере
Процедура НастроитьЭлементыФормы()
	
	НастроитьЗависимыеЭлементыФормы(ЭтаФорма);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура НастроитьЗависимыеЭлементыФормы(Форма, СписокРеквизитов = "")
	
	Объект = Форма.Объект;
	Элементы = Форма.Элементы;
	
	Инициализация = ПустаяСтрока(СписокРеквизитов);
	СтруктураРеквизитов = Новый Структура(СписокРеквизитов);
	
	Если СтруктураРеквизитов.Свойство("Комментарий")
		ИЛИ Инициализация Тогда
		
		Элементы.СтраницаДополнительно.Картинка = ОбщегоНазначенияКлиентСервер.КартинкаКомментария(Объект.Комментарий);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСлужебныеРеквизиты()
	
	ЗаполнитьПризнакХарактеристикиИспользуются = Новый Структура("Номенклатура", "ХарактеристикиИспользуются");
	ЗаполнитьПризнакТипНоменклатуры = Новый Структура("Номенклатура", "ТипНоменклатуры");
	
	СтруктураДействий = Новый Структура("ЗаполнитьПризнакХарактеристикиИспользуются, ЗаполнитьПризнакТипНоменклатуры",
		ЗаполнитьПризнакХарактеристикиИспользуются,
		ЗаполнитьПризнакТипНоменклатуры);
		
	НоменклатураСервер.ЗаполнитьСлужебныеРеквизитыПоНоменклатуреВКоллекции(
		Объект.УвеличениеПотребностей, СтруктураДействий);
		
	НоменклатураСервер.ЗаполнитьСлужебныеРеквизитыПоНоменклатуреВКоллекции(
		Объект.УменьшениеПотребностей, СтруктураДействий)
КонецПроцедуры

&НаСервере
Процедура НоменклатураПриИзмененииСервер(КэшированныеЗначения, Корректировка = Ложь)
	
	Действия = Новый Структура;
	Если Корректировка Тогда
		Действия.Вставить("ПроверитьХарактеристикуПоВладельцу", ХарактеристикаКорректировка);
	Иначе
		Действия.Вставить("ПроверитьХарактеристикуПоВладельцу", Характеристика);
	КонецЕсли;
	
	Шапка = Новый Структура("Номенклатура, Характеристика, ХарактеристикиИспользуются");
	Если Корректировка Тогда
		Шапка.Вставить("Номенклатура", НоменклатураКорректировка);
		Шапка.Вставить("Характеристика",ХарактеристикаКорректировка );
	Иначе
		Шапка.Вставить("Номенклатура", Номенклатура);
		Шапка.Вставить("Характеристика",Характеристика);
	КонецЕсли;
	
	ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(Шапка, Действия, Неопределено);
	Если Корректировка Тогда
		ХарактеристикаКорректировка = Шапка.Характеристика;
	Иначе
		ЗаполнитьЗначенияСвойств(Объект, Шапка);
	КонецЕсли;
	
	Если Шапка.ХарактеристикиИспользуются Тогда
		Если Корректировка Тогда
			Элементы.ХарактеристикаКорректировка.Доступность = Истина;
			Элементы.ХарактеристикаКорректировка.ПодсказкаВвода = "";
		Иначе
			Элементы.Характеристика.Доступность = Истина;
			Элементы.Характеристика.ПодсказкаВвода = "";
		КонецЕсли;
	Иначе
		Если Корректировка Тогда
			Элементы.ХарактеристикаКорректировка.Доступность = Ложь;
			Элементы.ХарактеристикаКорректировка.ПодсказкаВвода = НСтр("ru = '<характеристики не используются>'");
		Иначе
			Элементы.Характеристика.Доступность = Ложь;
			Элементы.Характеристика.ПодсказкаВвода = НСтр("ru = '<характеристики не используются>'");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ДобавитьВСтруктуруДействияПриИзмененииНоменклатуры(СтруктураДействий, ТекущаяСтрока, ИмяТЧ)

	СтруктураДействий.Вставить("ЗаполнитьПризнакТипНоменклатуры", Новый Структура("Номенклатура", "ТипНоменклатуры"));
	СтруктураДействий.Вставить("ПроверитьХарактеристикуПоВладельцу", ТекущаяСтрока.Характеристика);
	СтруктураДействий.Вставить("ПроверитьЗаполнитьУпаковкуПоВладельцу", ТекущаяСтрока.Упаковка);
	СтруктураДействий.Вставить("НоменклатураПриИзмененииПереопределяемый", Новый Структура("ИмяФормы, ИмяТабличнойЧасти", "ФормаДокумента", ИмяТЧ));
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ДобавитьВСтруктуруДействияПриИзмененииКоличестваУпаковок(СтруктураДействий)
	
	СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц", ПараметрыПересчетаКоличестваЕдиниц());
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПараметрыПересчетаКоличестваЕдиниц()

	ПараметрыПересчета = Новый Структура("НужноОкруглять", Ложь);
	Возврат ПараметрыПересчета;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеВидимостью(Форма)
	
	Форма.Элементы.Потребность.Видимость = Форма.УправлениеПроцессомПланирования;
	Форма.Элементы.Обеспечить.Видимость = Форма.УправлениеПроцессомПланирования;
	Форма.Элементы.Остаток.Видимость = Форма.УправлениеПроцессомПланирования;
	Форма.Элементы.КОбеспечениюКорректировка.Видимость = Форма.УправлениеПроцессомПланирования;
	Форма.Элементы.НоменклатураЕдиницаИзмерения.Видимость = Форма.УправлениеПроцессомПланирования;
	Форма.Элементы.НоменклатураЕдиницаИзмерения2.Видимость = Форма.УправлениеПроцессомПланирования;
	Форма.Элементы.НоменклатураКорректировкаЕдиницаИзмерения.Видимость = Форма.УправлениеПроцессомПланирования;
	Форма.Элементы.НоменклатураКорректировкаЕдиницаИзмерения2.Видимость = Форма.УправлениеПроцессомПланирования;
	
	Форма.Элементы.Назначение.Видимость = Форма.ПланированиеПоНазначениям;
	Форма.Элементы.НазначениеКорректировка.Видимость = Форма.ПланированиеПоНазначениям;
	Форма.Элементы.УменьшениеПотребностейНазначение.Видимость = Форма.ПланированиеПоНазначениям;
	Форма.Элементы.УвеличениеПотребностейНазначение.Видимость = Форма.ПланированиеПоНазначениям;
	
	Форма.Элементы.Сценарий.ТолькоПросмотр = ЗначениеЗаполнено(Форма.Объект.План);
	Форма.Элементы.ВидПлана.ТолькоПросмотр = ЗначениеЗаполнено(Форма.Объект.План);
	
	Форма.Элементы.ГруппаУпрощенныйРежим.Видимость = Форма.РежимВводаКорректировки = 0;
	Форма.Элементы.ГруппаУменьшениеПотребностей.Видимость = Форма.РежимВводаКорректировки = 1;
	Форма.Элементы.ГруппаУвеличениеПотребностей.Видимость = Форма.РежимВводаКорректировки = 1;
	
	Форма.Элементы.Декорация1.Видимость = Форма.Объект.Статус = ПредопределенноеЗначение("Перечисление.СтатусыПлановыхКорректировок.Отменена");
	
КонецПроцедуры

#Область РаботаСБуферомОбмена

&НаКлиенте
Процедура СкопироватьСтрокиТЧ(ИмяТЧ)

	ТаблицаФормы = Элементы[ИмяТЧ];
	
	Если РаботаСТабличнымиЧастямиКлиент.ВыбранаСтрокаДляВыполненияКоманды(ТаблицаФормы) Тогда
    	СкопироватьСтрокиНаСервере(ИмяТЧ);
    	РаботаСТабличнымиЧастямиКлиент.ОповеститьПользователяОКопированииСтрок(ТаблицаФормы.ВыделенныеСтроки.Количество());
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура СкопироватьСтрокиНаСервере(ИмяТЧ)
	
	РаботаСТабличнымиЧастями.СкопироватьСтрокиВБуферОбмена(Объект[ИмяТЧ], Элементы[ИмяТЧ].ВыделенныеСтроки);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьСтрокиИзБуфераОбмена(ИмяТЧ)
	
	КоличествоСтрокДоВставки = Объект[ИмяТЧ].Количество();
	
	ПолучитьСтрокиИзБуфераОбменаНаСервере(ИмяТЧ);
	
	КоличествоВставленных = Объект[ИмяТЧ].Количество() - КоличествоСтрокДоВставки;
	РаботаСТабличнымиЧастямиКлиент.ОповеститьПользователяОВставкеСтрок(КоличествоВставленных);
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьСтрокиИзБуфераОбменаНаСервере(ИмяТЧ)
	
	ПараметрыОтбора = Новый Соответствие;
  	ПараметрыОтбора.Вставить("Номенклатура.ТипНоменклатуры", НоменклатураКлиентСервер.ОтборПоТоваруМногооборотнойТареУслугеРаботе(Ложь));
  
  	Колонки = "Номенклатура,Характеристика,Упаковка,КоличествоУпаковок,Количество,Цена";
  
  	СтрокиИзБуфера = РаботаСТабличнымиЧастями.СтрокиИзБуфераОбмена(ПараметрыОтбора, Колонки);
	
	СтруктураДействий = Новый Структура;
	ДобавитьВСтруктуруДействияПриИзмененииКоличестваУпаковок(СтруктураДействий);
	
	КэшированныеЗначения = ОбработкаТабличнойЧастиКлиентСервер.ПолучитьСтруктуруКэшируемыеЗначения();
	
	Для каждого СтрокаИзБуфера Из СтрокиИзБуфера Цикл
		
		ТабличнаяЧасть = Объект[ИмяТЧ]; // ДанныеФормыКоллекция -   
		ТекущаяСтрока = ТабличнаяЧасть.Добавить();
		
		ЗаполнитьЗначенияСвойств(ТекущаяСтрока, СтрокаИзБуфера, "Номенклатура,Характеристика,Упаковка,КоличествоУпаковок");
		
		ДобавитьВСтруктуруДействияПриИзмененииНоменклатуры(СтруктураДействий, ТекущаяСтрока, ИмяТЧ);
		
		ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьКомандБуфераОбмена(Форма, ДоступностьРеквизитов)
	
	МассивЭлементов = Новый Массив();
	МассивЭлементов.Добавить("УменьшениеПотребностейУменьшениеПотребностей_ВставитьСтроки");
	МассивЭлементов.Добавить("УменьшениеПотребностейКонтекстноеМенюУменьшениеПотребностей_ВставитьСтроки");
	МассивЭлементов.Добавить("УвеличениеПотребностейУвеличениеПотребностей_ВставитьСтроки");
	МассивЭлементов.Добавить("УвеличениеПотребностейКонтекстноеМенюУвеличениеПотребностей_ВставитьСтроки");
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементовФормы(Форма.Элементы, МассивЭлементов, "Доступность", ДоступностьРеквизитов);
	
КонецПроцедуры

#КонецОбласти

// СтандартныеПодсистемы.Свойства 

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()

	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект);

КонецПроцедуры

// Конец СтандартныеПодсистемы.Свойства

// СтандартныеПодсистемы.РаботаСФайлами
&НаКлиенте
Процедура Подключаемый_КомандаПанелиПрисоединенныхФайлов(Команда)
	 РаботаСФайламиКлиент.КомандаУправленияПрисоединеннымиФайлами(ЭтотОбъект, Команда);
КонецПроцедуры
// Конец СтандартныеПодсистемы.РаботаСФайлами

// СтандартныеПодсистемы.РаботаСФайлами
&НаКлиенте
Процедура Подключаемый_ПолеПредпросмотраПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	 РаботаСФайламиКлиент.ПолеПредпросмотраПроверкаПеретаскивания(ЭтотОбъект, Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.РаботаСФайлами

// СтандартныеПодсистемы.РаботаСФайлами
&НаКлиенте
Процедура Подключаемый_ПолеПредпросмотраПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	 РаботаСФайламиКлиент.ПолеПредпросмотраПеретаскивание(ЭтотОбъект, Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.РаботаСФайлами

// СтандартныеПодсистемы.РаботаСФайлами
&НаКлиенте
Процедура Подключаемый_ПолеПредпросмотраНажатие(Элемент, СтандартнаяОбработка)
	 РаботаСФайламиКлиент.ПолеПредпросмотраНажатие(ЭтотОбъект, Элемент, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.РаботаСФайлами

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьРеквизитыКорректировки(Форма)
	
	Если Форма.Объект.УменьшениеПотребностей.Количество() > 0 Тогда
		СтрокаУменьшениеПотребностей = Форма.Объект.УменьшениеПотребностей[0];
		Форма.Номенклатура = СтрокаУменьшениеПотребностей.Номенклатура;
		Форма.Характеристика = СтрокаУменьшениеПотребностей.Характеристика;
		Форма.Назначение = СтрокаУменьшениеПотребностей.Назначение;
		Форма.ККорректировке = СтрокаУменьшениеПотребностей.Количество;
	КонецЕсли;
	
	Если Форма.Объект.УвеличениеПотребностей.Количество() > 0 Тогда
		СтрокаУвеличениеПотребностей = Форма.Объект.УвеличениеПотребностей[0];
		Форма.НоменклатураКорректировка = СтрокаУвеличениеПотребностей.Номенклатура;
		Форма.ХарактеристикаКорректировка = СтрокаУвеличениеПотребностей.Характеристика;
		Форма.НазначениеКорректировка = СтрокаУвеличениеПотребностей.Назначение;
		Форма.ККорректировкеКорректировка = СтрокаУвеличениеПотребностей.Количество;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьТЧКорректировкиПотребностей(Форма, ТекущийОбъект)
	
	ТекущийОбъект.УменьшениеПотребностей.Очистить();
	ТекущийОбъект.УвеличениеПотребностей.Очистить();
	
	СтрокаУменьшениеПотребностей = ТекущийОбъект.УменьшениеПотребностей.Добавить();
	СтрокаУменьшениеПотребностей.Номенклатура = Форма.Номенклатура;
	СтрокаУменьшениеПотребностей.Характеристика = Форма.Характеристика;
	СтрокаУменьшениеПотребностей.Назначение = Форма.Назначение;
	СтрокаУменьшениеПотребностей.Количество = Форма.ККорректировке;
	СтрокаУменьшениеПотребностей.КоличествоУпаковок = Форма.ККорректировке;
	
	Если ЗначениеЗаполнено(Форма.НоменклатураКорректировка) Тогда
		СтрокаУвеличениеПотребностей = ТекущийОбъект.УвеличениеПотребностей.Добавить();
		СтрокаУвеличениеПотребностей.Номенклатура = Форма.НоменклатураКорректировка;
		СтрокаУвеличениеПотребностей.Характеристика = Форма.ХарактеристикаКорректировка;
		СтрокаУвеличениеПотребностей.Назначение = Форма.НазначениеКорректировка;
		СтрокаУвеличениеПотребностей.Количество = Форма.ККорректировкеКорректировка;
		СтрокаУвеличениеПотребностей.КоличествоУпаковок = Форма.ККорректировкеКорректировка;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьНачальныйОстатокЭтапа(Сценарий, ВидПлана, Период, Номенклатура, Характеристика, Назначение) 
	Запрос = Новый Запрос();
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	МАКСИМУМ(РасчетДефицитовПлановПоЭтапам.ПериодПланирования) КАК ПериодПланирования
	|ПОМЕСТИТЬ МаксимальныйПериодРасчетаДефицита
	|ИЗ
	|	РегистрСведений.РасчетДефицитовПлановПоЭтапам КАК РасчетДефицитовПлановПоЭтапам
	|ГДЕ
	|	РасчетДефицитовПлановПоЭтапам.Сценарий = &Сценарий
	|	И РасчетДефицитовПлановПоЭтапам.ВидПлана = &ВидПлана
	|	И РасчетДефицитовПлановПоЭтапам.ПериодПланирования <= &ПериодПланирования
	|	И РасчетДефицитовПлановПоЭтапам.Номенклатура = &Номенклатура
	|	И РасчетДефицитовПлановПоЭтапам.Характеристика = &Характеристика
	|	И РасчетДефицитовПлановПоЭтапам.Назначение = &Назначение
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	РасчетДефицитовПлановПоЭтапам.НачальныйОстаток КАК НачальныйОстаток
	|ИЗ
	|	РегистрСведений.РасчетДефицитовПлановПоЭтапам КАК РасчетДефицитовПлановПоЭтапам
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ МаксимальныйПериодРасчетаДефицита КАК МаксимальныйПериодРасчетаДефицита
	|		ПО РасчетДефицитовПлановПоЭтапам.ПериодПланирования = МаксимальныйПериодРасчетаДефицита.ПериодПланирования
	|ГДЕ
	|	РасчетДефицитовПлановПоЭтапам.Сценарий = &Сценарий
	|	И РасчетДефицитовПлановПоЭтапам.ВидПлана = &ВидПлана
	|	И РасчетДефицитовПлановПоЭтапам.ПериодПланирования <= &ПериодПланирования
	|	И РасчетДефицитовПлановПоЭтапам.Номенклатура = &Номенклатура
	|	И РасчетДефицитовПлановПоЭтапам.Характеристика = &Характеристика
	|	И РасчетДефицитовПлановПоЭтапам.Назначение = &Назначение";
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	Запрос.УстановитьПараметр("Характеристика", Характеристика);
	Запрос.УстановитьПараметр("Назначение", Назначение);
	Запрос.УстановитьПараметр("Сценарий", Сценарий);
	Запрос.УстановитьПараметр("ВидПлана", ВидПлана);
	Запрос.УстановитьПараметр("ПериодПланирования", Период);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.НачальныйОстаток;
	Иначе
		Возврат 0;
	КонецЕсли;
	
КонецФункции

&НаСервере
Функция ПолучитьНачальныйОстаток(Сценарий, ВидПлана, Период, Номенклатура, Характеристика, Назначение) 
	Запрос = Новый Запрос();
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	МАКСИМУМ(РасчетДефицитовПлановПоЭтапам.ПериодПланирования) КАК ПериодПланирования
	|ПОМЕСТИТЬ МаксимальныйПериодРасчетаДефицита
	|ИЗ
	|	РегистрСведений.РасчетДефицитовПлановПоЭтапам КАК РасчетДефицитовПлановПоЭтапам
	|ГДЕ
	|	РасчетДефицитовПлановПоЭтапам.Сценарий = &Сценарий
	|	И РасчетДефицитовПлановПоЭтапам.ВидПлана = &ВидПлана
	|	И РасчетДефицитовПлановПоЭтапам.ПериодПланирования <= &ПериодПланирования
	|	И РасчетДефицитовПлановПоЭтапам.Номенклатура = &Номенклатура
	|	И РасчетДефицитовПлановПоЭтапам.Характеристика = &Характеристика
	|	И РасчетДефицитовПлановПоЭтапам.Назначение = &Назначение
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	РасчетДефицитовПлановПоЭтапам.НачальныйОстаток КАК НачальныйОстаток
	|ИЗ
	|	РегистрСведений.РасчетДефицитовПлановПоЭтапам КАК РасчетДефицитовПлановПоЭтапам
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ МаксимальныйПериодРасчетаДефицита КАК МаксимальныйПериодРасчетаДефицита
	|		ПО РасчетДефицитовПлановПоЭтапам.ПериодПланирования = МаксимальныйПериодРасчетаДефицита.ПериодПланирования
	|ГДЕ
	|	РасчетДефицитовПлановПоЭтапам.Сценарий = &Сценарий
	|	И РасчетДефицитовПлановПоЭтапам.ВидПлана = &ВидПлана
	|	И РасчетДефицитовПлановПоЭтапам.ПериодПланирования <= &ПериодПланирования
	|	И РасчетДефицитовПлановПоЭтапам.Номенклатура = &Номенклатура
	|	И РасчетДефицитовПлановПоЭтапам.Характеристика = &Характеристика
	|	И РасчетДефицитовПлановПоЭтапам.Назначение = &Назначение";
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	Запрос.УстановитьПараметр("Характеристика", Характеристика);
	Запрос.УстановитьПараметр("Назначение", Назначение);
	Запрос.УстановитьПараметр("Сценарий", Сценарий);
	Запрос.УстановитьПараметр("ВидПлана", Справочники.ВидыПланов.ПустаяСсылка());
	Запрос.УстановитьПараметр("ПериодПланирования", Период);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.НачальныйОстаток;
	Иначе
		Возврат 0;
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура ПотребностьПриИзмененииНаСервере()
	Потребность = -ПолучитьНачальныйОстатокЭтапа(Объект.Сценарий,
		Объект.ВидПлана,
		Объект.Период,
		Номенклатура,
		Характеристика,
		Назначение);
	
	КОбеспечению = Потребность - ККорректировке;
КонецПроцедуры

&НаСервере
Процедура КорректировкаПриИзмененииНаСервере()
	Остаток = ПолучитьНачальныйОстаток(Объект.Сценарий,
		Объект.ВидПлана,
		Объект.Период,
		НоменклатураКорректировка,
		ХарактеристикаКорректировка,
		НазначениеКорректировка);
	КОбеспечениюКорректировка = Остаток - ККорректировкеКорректировка;
КонецПроцедуры

#КонецОбласти
