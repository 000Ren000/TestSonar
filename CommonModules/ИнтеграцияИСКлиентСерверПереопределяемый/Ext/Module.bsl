﻿
#Область СлужебныйПрограммныйИнтерфейс

#Область СерииНоменклатуры

// Процедура устанавливает использование статусов серий необязательного вида "Можно указать"
// для объектов метаданных подсистемы ГосИС.
//
// Параметры:
//  Использовать - Булево - разрешить использование статусов
//  ПараметрыУказанияСерий - Произвольный - Параметры указания серий.
Процедура ИспользоватьСтатусСерийМожноУказать(Использовать, ПараметрыУказанияСерий) Экспорт
	
	// (См. НоменклатураКлиентСервер.ПараметрыУказанияСерий)
	Если ПараметрыУказанияСерий.ПолноеИмяОбъекта = "Документ.ВходящаяТранспортнаяОперацияВЕТИС"
		Или ПараметрыУказанияСерий.ПолноеИмяОбъекта = "Документ.ЗапросСкладскогоЖурналаВЕТИС"
		Или ПараметрыУказанияСерий.ПолноеИмяОбъекта = "Документ.ИнвентаризацияПродукцииВЕТИС"
		Или ПараметрыУказанияСерий.ПолноеИмяОбъекта = "Документ.ИсходящаяТранспортнаяОперацияВЕТИС"
		Или ПараметрыУказанияСерий.ПолноеИмяОбъекта = "Документ.ПроизводственнаяОперацияВЕТИС"
		Или (СтрНачинаетсяС(ПараметрыУказанияСерий.ПолноеИмяОбъекта, "Обработка.ПроверкаИПодборПродукцииИСМП")
			Или СтрНачинаетсяС(ПараметрыУказанияСерий.ПолноеИмяОбъекта, "Обработка.ВиртуальнаяАгрегацияУпаковокИСМП")
			Или СтрНачинаетсяС(ПараметрыУказанияСерий.ПолноеИмяОбъекта, "Обработка.ПроверкаИПодборТабачнойПродукцииМОТП"))
			И ПараметрыУказанияСерий.ИмяПоляСклад = Неопределено
		Тогда
		Использовать = Истина;
	КонецЕсли;

КонецПроцедуры

// Функция проверяет необходимость указания серии в строке по статусу.
//
// Параметры:
//  ТребуетсяУказать    - Булево - в этом статусе требуется указание серий.
//  СтатусУказанияСерий - Число  - статус указания серии в строке табличной части
//
Процедура ПроверитьНеобходимоУказатьСерию(ТребуетсяУказать, СтатусУказанияСерий) Экспорт
	
	//++ НЕ ГОСИС
	ТребуетсяУказать = НоменклатураКлиентСервер.СтатусыСерийСерияНеУказана().Найти(СтатусУказанияСерий)<>Неопределено;
	//-- НЕ ГОСИС
	Возврат;
	
КонецПроцедуры

// В процедуре требуется определить признак использования серий по параметрам указания серий
//
// Параметры:
//  Использование - Булево - Признак использования серий
//  ПараметрыУказанияСерий - Произвольный - Параметры указания серий объекта конфигурации.
//
Процедура ИспользованиеСерийПоПараметрамУказанияСерий(Использование, ПараметрыУказанияСерий) Экспорт
	
	//++ НЕ ГОСИС
	Если ПараметрыУказанияСерий=Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ПараметрыУказанияСерий.Свойство("ИспользоватьСерииНоменклатуры") Тогда
		Использование = ПараметрыУказанияСерий.ИспользоватьСерииНоменклатуры;
	ИначеЕсли ПараметрыУказанияСерий.Свойство("ВыходныеИзделия") Тогда
		Использование = ПараметрыУказанияСерий.ВыходныеИзделия.ИспользоватьСерииНоменклатуры;
	КонецЕсли;
	//-- НЕ ГОСИС
	Возврат;
	
КонецПроцедуры

#КонецОбласти

// Заполняет представление строки номенклатуры.
//
// Параметры:
//  Представление  - Строка                                     - представление для заполнения,
//  Номенклатура   - ОпределяемыйТип.Номенклатура               - ссылка на номенклатуру,
//  Характеристика - ОпределяемыйТип.ХарактеристикаНоменклатуры - ссылка на характеристику номенклатуры,
//  Упаковка       - ОпределяемыйТип.Упаковка                   - ссылка на упаковку.
//  Серия          - ОпределяемыйТип.СерияНоменклатуры          - ссылка на серию номенклатуры.
Процедура ЗаполнитьПредставлениеНоменклатуры(Представление, Номенклатура, Характеристика, Упаковка, Серия) Экспорт
	
	//++ НЕ ГОСИС
	Представление = НоменклатураКлиентСервер.ПредставлениеНоменклатурыДляПечати(
		СокрЛП(Номенклатура),
		СокрЛП(Характеристика),
		Упаковка,
		Серия);
	//-- НЕ ГОСИС
	Возврат;
	
КонецПроцедуры

#КонецОбласти