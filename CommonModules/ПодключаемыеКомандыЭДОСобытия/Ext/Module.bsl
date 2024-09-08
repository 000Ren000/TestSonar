﻿#Область СлужебныйПрограммныйИнтерфейс

// Заполняет список команд ЭДО данными других подсистем БЭД.
// 
// Параметры:
//  СоставКомандЭДО - Структура - структура состава команд ЭДО.
//    Исходящие    - Массив - состав объектов, например "Документ.РеализацияТоваровУслуг".
//    Входящие     - Массив - состав объектов.
//    БезПодписи   - Массив - состав объектов для обмена без ЭП.
//    Интеркампани - Массив - состав объектов Интеркампани.
//    Контрагенты  - Массив - состав объектов Контрагенты.
//    Организации  - Массив - состав объектов Организации.
//    Договоры     - Массив - состав объектов Договоры.
//
Процедура ПриОпределенииСоставаКомандЭДО(СоставКоманд) Экспорт

	Если ОбщегоНазначения.ПодсистемаСуществует("ЭлектронноеВзаимодействие.КоммерческиеПредложения.КоммерческиеПредложенияДокументы.КоммерческоеПредложениеКлиенту") Тогда
		МодульПодсистемы = ОбщегоНазначения.ОбщийМодуль("Документы.КоммерческоеПредложениеКлиенту");
		МодульПодсистемы.ПриОпределенииСоставаКомандЭДО(СоставКоманд);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЭлектронноеВзаимодействие.КоммерческиеПредложения.КоммерческиеПредложенияДокументы.КоммерческоеПредложениеПоставщика") Тогда
		МодульПодсистемы = ОбщегоНазначения.ОбщийМодуль("Документы.КоммерческоеПредложениеПоставщика");
		МодульПодсистемы.ПриОпределенииСоставаКомандЭДО(СоставКоманд);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЭлектронноеВзаимодействие.КоммерческиеПредложения.КоммерческиеПредложенияДокументы.ЗапросКоммерческогоПредложенияОтКлиента") Тогда
		МодульПодсистемы = ОбщегоНазначения.ОбщийМодуль("Документы.ЗапросКоммерческогоПредложенияОтКлиента");
		МодульПодсистемы.ПриОпределенииСоставаКомандЭДО(СоставКоманд);
	КонецЕсли;

	Если ОбщегоНазначения.ПодсистемаСуществует("ЭлектронноеВзаимодействие.ЭлектронноеАктированиеЕИС.АктированиеДляЗаказчиков") Тогда
		МодульПодсистемы = ОбщегоНазначения.ОбщийМодуль("ЭлектронноеАктированиеЗаказчикаЕИС");
		МодульПодсистемы.ПриОпределенииСоставаКомандЭДО(СоставКоманд);
	КонецЕсли;
	
	ОбменСКонтрагентамиПереопределяемый.ПодготовитьСтруктуруОбъектовКомандЭДО(СоставКоманд);
	ОбменСКонтрагентамиПереопределяемый.ПриОпределенииСоставаКомандЭДООснованияПрикладногоЭлектронногоДокумента(СоставКоманд);
		
	
КонецПроцедуры

// Дополняет список команд ЭДО командами других подсистем БЭД.
//
// Параметры:
//   СоставКомандЭДО - Структура - структура состава команд ЭДО.
//    Исходящие    - Массив - состав объектов, например "Документ.РеализацияТоваровУслуг".
//    Входящие     - Массив - состав объектов.
//    БезПодписи   - Массив - состав объектов для обмена без ЭП.
//    Интеркампани - Массив - состав объектов Интеркампани.
//    Контрагенты  - Массив - состав объектов Контрагенты.
//    Организации  - Массив - состав объектов Организации.
//    Договоры     - Массив - состав объектов Договоры.
//  ПолноеИмя - Строка - имя объекта, например "Документ.РеализацияТоваровУслуг".
//  НаправлениеЭД - Перечисление.НаправлениеЭД - параметр отбора входящих или исходящих документов.
//  КомандыЭДО - ТаблицаЗначений - подготавливаемый список команд ЭДО.
//
Процедура ПриОпределенииСпискаКомандЭДО(Знач СоставКоманд, Знач ПолноеИмя, Знач НаправлениеЭД, КомандыЭДО) Экспорт
	
	ИнтерфейсДокументовЭДО.ПриОпределенииСпискаКомандЭДО(СоставКоманд, ПолноеИмя, НаправлениеЭД, КомандыЭДО);
		
	ЕстьПодсистемаБизнесСеть = ОбщегоНазначения.ПодсистемаСуществует("ЭлектронноеВзаимодействие.БизнесСеть");
	Если ЕстьПодсистемаБизнесСеть Тогда
		МодульБизнесСеть = ОбщегоНазначения.ОбщийМодуль("БизнесСеть");
		МодульБизнесСеть.ПриОпределенииСпискаКомандЭДО(СоставКоманд, ПолноеИмя, НаправлениеЭД, КомандыЭДО);
	КонецЕсли;
	
	ЕстьПодсистемаИнтеграцияShare = ОбщегоНазначения.ПодсистемаСуществует("ЭлектронноеВзаимодействие.СервисShare");
	Если ЕстьПодсистемаИнтеграцияShare Тогда
		МодульИнтеграцияShare = ОбщегоНазначения.ОбщийМодуль("ИнтеграцияShare");
		МодульИнтеграцияShare.ПриОпределенииСпискаКомандЭДО(СоставКоманд, ПолноеИмя, НаправлениеЭД, КомандыЭДО);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти