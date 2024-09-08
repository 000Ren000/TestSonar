﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	Если КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "ВыводитьПлановыеДвижения").Значение Тогда
		УстановитьПривилегированныйРежим(Истина);
		РегистрыСведений.ГрафикПлатежей.РассчитатьГрафикПлатежейПоПоступлениямОтБанкаПоЭквайрингу();
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	ПользовательскиеНастройкиМодифицированы = Ложь;
	
	УстановитьОбязательныеНастройки(КомпоновщикНастроек, ПользовательскиеНастройкиМодифицированы);
	
	НастройкиОсновнойСхемы = КомпоновщикНастроек.ПолучитьНастройки();
	
	// Сформируем отчет
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиОсновнойСхемы, ДанныеРасшифровки);
	
	КомпоновкаДанныхСервер.УстановитьЗаголовкиМакетаКомпоновки(СоответствиеЗаголовковПолей(), МакетКомпоновки);
	
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки,, ДанныеРасшифровки, Истина);
	
	ПроцессорВыводаВТабличныйДокумент = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВыводаВТабличныйДокумент.УстановитьДокумент(ДокументРезультат);
	ПроцессорВыводаВТабличныйДокумент.Вывести(ПроцессорКомпоновкиДанных);
	
	// Сообщим форме отчета, что настройки модифицированы
	Если ПользовательскиеНастройкиМодифицированы Тогда
		КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("ПользовательскиеНастройкиМодифицированы", Истина);
	КонецЕсли;
	
	ОтчетПустой = ОтчетыСервер.ОтчетПустой(ЭтотОбъект, ПроцессорКомпоновкиДанных);
	КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("ОтчетПустой", ОтчетПустой);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьОбязательныеНастройки(КомпоновщикНастроек, ПользовательскиеНастройкиМодифицированы)
	
	КомпоновкаДанныхСервер.НастроитьДинамическийПериод(СхемаКомпоновкиДанных, КомпоновщикНастроек, Истина, "Периоды.");
	
КонецПроцедуры

Функция СоответствиеЗаголовковПолей()
	
	ИспользоватьНесколькоВалют = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоВалют");
	ДанныеОтчета = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "ДанныеОтчета").Значение;
	
	СоответствиеЗаголовковПолей = Новый Соответствие;
	Если ИспользоватьНесколькоВалют Тогда
		Если ДанныеОтчета = 1 ИЛИ ДанныеОтчета = 3 Тогда
			СоответствиеЗаголовковПолей.Вставить("1", "");
		ИначеЕсли ДанныеОтчета = 2 Тогда
			ПараметрВалюта = Константы.ВалютаУправленческогоУчета.Получить();
			СоответствиеЗаголовковПолей.Вставить("1", "(" + ПараметрВалюта + ")");
		КонецЕсли;
	Иначе
		СоответствиеЗаголовковПолей.Вставить("1", "");
	КонецЕсли;
	
	Возврат СоответствиеЗаголовковПолей;
	
КонецФункции

#КонецОбласти

#КонецЕсли