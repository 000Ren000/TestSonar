﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Контракт = Параметры.Контракт;
	ДанныеКонтракта = ЭлектронноеАктированиеЕИС.ДанныеГосударственногоКонтракта(Контракт);
	Идентификатор = Параметры.ИдентификаторОбъектаЗакупки;
	КодМНН = Параметры.КодМНН;
	КодЛП = Параметры.КодЛП;
	ИдентификаторЛП = Параметры.ИдентификаторЛП;
	
	Для каждого Объект Из ДанныеКонтракта.ОбъектыЗакупки Цикл
		Если Объект.Идентификатор = Идентификатор Тогда
			СведенияОЛекарственномПрепарате = Объект.СведенияОЛекарственномПрепарате;
			ВключенВЖНВЛП = СведенияОЛекарственномПрепарате.ВключенВЖНВЛП;
			СрокГодности = СведенияОЛекарственномПрепарате.СрокГодности;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Для каждого Позиция Из СведенияОЛекарственномПрепарате.СписокМНН Цикл
		Если Позиция.КодМНН = КодМНН Тогда
			ПозицияМНН = Позиция;
			МеждународноеНепатентованноеНаименование = Позиция.НаименованиеМНН;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Для каждого Позиция Из ПозицияМНН.ПозицииПоТорговомуНаименованиюЛП Цикл
		Если Позиция.Идентификатор = ИдентификаторЛП Тогда
			ПозицияЛП = Позиция;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	ТорговоеНаименованиеЛП = ПозицияЛП.ТорговоеНаименование;
	ВидПервичнойУпаковки = ПозицияЛП.НаименованиеВидаПервичнойУпаковки;
	ДозировкаНаименование = ПозицияЛП.НаименованиеПотребительскойЕдиницыДозировки;
	ДозировкаЗначение = ПозицияЛП.ЗначениеДозировки;
	ИдентификаторЛП = ПозицияЛП.ИдентификаторПоСправочникуЛП;
	КоличествоЛекарственныхФормВПервичнойУпаковке = ПозицияЛП.КоличествоЛекарственныхФормВПервичнойУпаковке;
	КоличествоЛекарственныхФормВПотребительскойУпаковке = ПозицияЛП.КоличествоЛекарственныхФормВПотребительскойУпаковке;
	КоличествоПервичныхУпаковокВПотребительскойУпаковке = ПозицияЛП.КоличествоПервичныхУпаковокВПотребительскойУпаковке;
	НаименованиеВидаПервичнойУпаковки = ПозицияЛП.НаименованиеВидаПервичнойУпаковки;
	НаименованиеЕдиницыИзмеренияДозировки = ПозицияЛП.НаименованиеЕдиницыИзмеренияДозировки;
	НаименованиеЛекарственнойФормы = ПозицияЛП.НаименованиеЛекарственнойФормы;
	НациональноеОбозначениеЕдиницыИзмеренияДозировки = ПозицияЛП.НациональноеОбозначениеЕдиницыИзмеренияДозировки;
	ПолноеНаименованиеЕдиницыИзмеренияДозировки = ПозицияЛП.ПолноеНаименованиеЕдиницыИзмеренияДозировки;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗакрытьФорму(Команда)
	ЭтотОбъект.Закрыть();
КонецПроцедуры

#КонецОбласти