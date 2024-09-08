﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - Форма отчета.
//   КлючВарианта - Строка - Имя предопределенного варианта отчета или уникальный идентификатор пользовательского.
//   Настройки - См. ОтчетыКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	
	Настройки.События.ПередЗагрузкойНастроекВКомпоновщик = Истина;
	
КонецПроцедуры

// Вызывается перед загрузкой новых настроек. Используется для изменения схемы компоновки.
//
// Параметры:
//	Контекст							- Произвольный									- параметры контекста, в котором используется отчет.
//	КлючСхемы							- Строка										- идентификатор текущей схемы компоновщика настроек.
//	КлючВарианта						- Строка, Неопределено							- имя предопределенного или уникальный идентификатор пользовательского
//																							варианта отчета.
//																							Неопределено когда вызов для варианта расшифровки или без контекста.
//	НовыеНастройкиКД					- НастройкиКомпоновкиДанных, Неопределено		- настройки варианта отчета, которые будут загружены
//																							в компоновщик настроек после его инициализации.
//																							Неопределено когда настройки варианта не надо загружать (уже загружены ранее).
//	НовыеПользовательскиеНастройкиКД	- ПользовательскиеНастройкиКомпоновкиДанных,
//											Неопределено								- пользовательские настройки, которые будут загружены в компоновщик
//																							настроек после его инициализации.
//																							Неопределено когда пользовательские настройки не надо загружать
//																							(уже загружены ранее).
//
Процедура ПередЗагрузкойНастроекВКомпоновщик(Контекст, КлючСхемы, КлючВарианта, НовыеНастройкиКД, НовыеПользовательскиеНастройкиКД) Экспорт
	
	Если КлючСхемы = КлючВарианта Тогда
		Возврат;
	КонецЕсли;
	
	Если НовыеНастройкиКД = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	КлючСхемы		= КлючВарианта;
	ЗаголовкиПолей	= ПараметризуемыеЗаголовкиПолей();
	
	КомпоновкаДанныхСервер.УстановитьЗаголовкиВыбранныхПолей(НовыеНастройкиКД.Выбор.Элементы, ЗаголовкиПолей);
	
	Если ТипЗнч(НовыеПользовательскиеНастройкиКД) <> Тип("ПользовательскиеНастройкиКомпоновкиДанных") Тогда
		Возврат;
	КонецЕсли;
	
	ИдентификаторНастройки = НовыеНастройкиКД.Выбор.ИдентификаторПользовательскойНастройки;
	
	Если ЗначениеЗаполнено(ИдентификаторНастройки) Тогда
		НайденныйЭлементНастройки = НовыеПользовательскиеНастройкиКД.Элементы.Найти(ИдентификаторНастройки);
		
		Если НайденныйЭлементНастройки <> Неопределено Тогда 
			КомпоновкаДанныхСервер.УстановитьЗаголовкиВыбранныхПолей(НайденныйЭлементНастройки.Элементы, ЗаголовкиПолей);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПользовательскиеНастройкиМодифицированы = Ложь;
	
	УстановитьОбязательныеНастройки(ПользовательскиеНастройкиМодифицированы);
	
	НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();
	
	ТекстЗапроса = СхемаКомпоновкиДанных.НаборыДанных.Запрос.Запрос;

	ТекстЗапроса = СтрЗаменить(
		ТекстЗапроса, 
		"&ТекстЗапросаВесНоменклатуры", 
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаВесУпаковки("ЗаданиеТорговомуПредставителюТовары.Номенклатура.ЕдиницаИзмерения", "ЗаданиеТорговомуПредставителюТовары.Номенклатура"));
		
	ТекстЗапроса = СтрЗаменить(
		ТекстЗапроса, 
		"&ТекстЗапросаОбъемНоменклатуры", 
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаОбъемУпаковки("ЗаданиеТорговомуПредставителюТовары.Номенклатура.ЕдиницаИзмерения", "ЗаданиеТорговомуПредставителюТовары.Номенклатура"));

	СхемаКомпоновкиДанных.НаборыДанных.Запрос.Запрос = ТекстЗапроса;
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиОтчета, ДанныеРасшифровки);

	КомпоновкаДанныхСервер.УстановитьЗаголовкиМакетаКомпоновки(ПараметризуемыеЗаголовкиПолей(), МакетКомпоновки);
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, , ДанныеРасшифровки, Истина);

	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	КомпоновкаДанныхСервер.СкрытьВспомогательныеПараметрыОтчета(СхемаКомпоновкиДанных, КомпоновщикНастроек, ДокументРезультат, ВспомогательныеПараметрыОтчета());
	
	// Сообщим форме отчета, что настройки модифицированы
	Если ПользовательскиеНастройкиМодифицированы Тогда
		КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("ПользовательскиеНастройкиМодифицированы", Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
	
Процедура УстановитьОбязательныеНастройки(ПользовательскиеНастройкиМодифицированы)
	
	СегментыСервер.ВключитьОтборПоСегментуНоменклатурыВСКД(КомпоновщикНастроек);
	
КонецПроцедуры

Функция ВспомогательныеПараметрыОтчета()
	
	ВспомогательныеПараметры = Новый Массив;
	
	ВспомогательныеПараметры.Добавить("КоличественныеИтогиПоЕдИзм");
	
	КомпоновкаДанныхСервер.ДобавитьВспомогательныеПараметрыОтчетаПоФункциональнымОпциям(ВспомогательныеПараметры);
	
	Возврат ВспомогательныеПараметры;

КонецФункции

Функция ПараметризуемыеЗаголовкиПолей()
	
	Возврат КомпоновкаДанныхСервер.СоответствиеЗаголовковПолейЕдиницИзмерений(КомпоновщикНастроек);
	
КонецФункции

#КонецОбласти

#КонецЕсли