﻿
#Область СлужебныеПроцедурыИФункции

// Серверный обработчик события ОбработкаПолученияДанныхВыбора справочника Назначения.
//
Процедура НазначенияОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	ДанныеВыбора = Справочники.Назначения.ЗаполнитьДанныеВыбора(Параметры);
	
КонецПроцедуры

Процедура ДобавитьОтборИсключенияПартнера(СтруктураОтборов) Экспорт
	
	Справочники.Назначения.ДобавитьОтборИсключенияПартнера(СтруктураОтборов);
	
КонецПроцедуры

#КонецОбласти

