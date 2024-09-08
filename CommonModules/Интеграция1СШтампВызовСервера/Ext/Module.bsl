﻿
#Область СлужебныйПрограммныйИнтерфейс

Функция ДлительнаяОперацияДобавленияШтамповВДокумент(Знач ПараметрыДобавленияШтампов, Знач ТаймаутПолученияСтатусаВыполненияЗаданияВСервисе = Неопределено) Экспорт
	
	ИмяФункции = "Интеграция1СШтамп.РезультатДобавленияШтамповВДокумент";
	
	НаименованиеЗадания = НСтр("ru = '1С:Штамп. Добавление штампов в документ.'",
		ОбщегоНазначения.КодОсновногоЯзыка());
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне();
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НаименованиеЗадания;
	ПараметрыВыполнения.ОжидатьЗавершение           = 0;
	ПараметрыВыполнения.ЗапуститьВФоне              = Истина;

	Возврат ДлительныеОперации.ВыполнитьФункцию(
		ПараметрыВыполнения,
		ИмяФункции,
		ПараметрыДобавленияШтампов,
		ТаймаутПолученияСтатусаВыполненияЗаданияВСервисе);

КонецФункции

#КонецОбласти

