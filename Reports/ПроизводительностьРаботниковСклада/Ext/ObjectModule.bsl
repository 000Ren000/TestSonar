﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПользовательскиеНастройкиМодифицированы = Ложь;

	НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();
	
	ТекстЗапроса = СхемаКомпоновкиДанных.НаборыДанных.ДвижениеТоваров.Запрос;

	ТекстЗапроса = СтрЗаменить(
		ТекстЗапроса, 
		"&ТекстЗапросаВесУпаковки1", 
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаВесУпаковки("ТоварыВЯчейкахОбороты.Упаковка", "ТоварыВЯчейкахОбороты.Номенклатура"));
		
	ТекстЗапроса = СтрЗаменить(
		ТекстЗапроса, 
		"&ТекстЗапросаОбъемУпаковки1", 
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаОбъемУпаковки("ТоварыВЯчейкахОбороты.Упаковка", "ТоварыВЯчейкахОбороты.Номенклатура"));

	ТекстЗапроса = СтрЗаменить(
		ТекстЗапроса, 
		"&ТекстЗапросаВесУпаковки2", 
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаВесУпаковки("ПересчетТоваровТовары.Упаковка", "ПересчетТоваровТовары.Номенклатура"));
		
	ТекстЗапроса = СтрЗаменить(
		ТекстЗапроса, 
		"&ТекстЗапросаОбъемУпаковки2", 
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаОбъемУпаковки("ПересчетТоваровТовары.Упаковка", "ПересчетТоваровТовары.Номенклатура"));

	СхемаКомпоновкиДанных.НаборыДанных.ДвижениеТоваров.Запрос = ТекстЗапроса;
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиОтчета, ДанныеРасшифровки);

	КомпоновкаДанныхСервер.УстановитьЗаголовкиМакетаКомпоновки(ПараметризуемыеЗаголовкиПолей(), МакетКомпоновки);
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, , ДанныеРасшифровки, Истина);

	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	// Сообщим форме отчета, что настройки модифицированы
	Если ПользовательскиеНастройкиМодифицированы Тогда
		КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("ПользовательскиеНастройкиМодифицированы", Истина);
	КонецЕсли;
	
	КомпоновкаДанныхКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ПараметрВидОперацииПриемка", НСтр("ru = 'Приемка'"));
	КомпоновкаДанныхКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ПараметрВидОперацииКонтроль", НСтр("ru = 'Контроль'"));
	КомпоновкаДанныхКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ПараметрВидОперацииПересчет", НСтр("ru = 'Пересчет'"));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПараметризуемыеЗаголовкиПолей()
	
	Возврат КомпоновкаДанныхСервер.СоответствиеЗаголовковПолейЕдиницИзмерений(КомпоновщикНастроек);
	
КонецФункции

#КонецОбласти

#КонецЕсли