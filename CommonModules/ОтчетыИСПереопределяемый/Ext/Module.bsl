﻿#Область ПрограммныйИнтерфейс

#Область ОтчетыОРасхождениях

//Формирует текст запроса по составу продукции ГосИС оформленных прикладных документов.
//
// Параметры:
//   ТекстЗапроса  - Строка - заполняемый текст запроса.
//   ОтчетОбъект - ОтчетОбъект - отчет ГосИС, использующий переопределение
//
Процедура ПриПереопределенииТекстаЗапроса(ТекстЗапроса, ОтчетОбъект) Экспорт
	
	//++ НЕ ГОСИС
	ОтчетыИСУТ.ПриОпределенииТекстаЗапросаОформленныхДокументов(ТекстЗапроса, ОтчетОбъект);
	//-- НЕ ГОСИС
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
