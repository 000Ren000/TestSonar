﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	НепроверяемыеРеквизиты = Новый Массив;
	
	Если Не ЗначениеЗаполнено(ВнутреннийИдентификаторЕИС) Тогда
		ПроверяемыеРеквизиты.Добавить("Состояние");
		ПроверяемыеРеквизиты.Добавить("ДатаЗаключения");
		ПроверяемыеРеквизиты.Добавить("ГодОкончанияСрокаДействия");
		
		Если ТипНаправленияДеятельности = Перечисления.ТипыНаправленийДеятельности.КонтрактГОЗ Тогда
			ПроверяемыеРеквизиты.Добавить("УполномоченныйБанк");
			ПроверяемыеРеквизиты.Добавить("НомерГОЗ");
			ПроверяемыеРеквизиты.Добавить("КодСпособаОпределенияПоставщика");
			ПроверяемыеРеквизиты.Добавить("КодГосударственногоЗаказчика");
			ПроверяемыеРеквизиты.Добавить("ПорядковыйНомер");
			ПроверяемыеРеквизиты.Добавить("ДополнительныеРазряды");
		КонецЕсли;
	КонецЕсли;
	
	Если ТипНаправленияДеятельности = Перечисления.ТипыНаправленийДеятельности.ГосударственныйКонтракт Тогда
	
		НепроверяемыеРеквизиты.Добавить("УполномоченныйБанк");
		НепроверяемыеРеквизиты.Добавить("КодСпособаОпределенияПоставщика");
		НепроверяемыеРеквизиты.Добавить("КодГосударственногоЗаказчика");
		НепроверяемыеРеквизиты.Добавить("ПорядковыйНомер");
		НепроверяемыеРеквизиты.Добавить("ДополнительныеРазряды");
		
		Если ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций") Тогда
			ПроверяемыеРеквизиты.Добавить("Организация");
		КонецЕсли;
	
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, НепроверяемыеРеквизиты);
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
	КонецЕсли;

КонецПроцедуры

Процедура ПередЗаписью(Отказ)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	Если ТипНаправленияДеятельности = Перечисления.ТипыНаправленийДеятельности.ГосударственныйКонтракт Тогда
		УполномоченныйБанк = Справочники.КлассификаторБанков.ПустаяСсылка();
	КонецЕсли;

КонецПроцедуры
	
Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	// ЭлектронноеВзаимодействие.ЭлектронноеАктированиеЕИС
	ОтражениеВУчетеЭДО.ВыполнитьКонтрольОтраженияВУчетеПриЗаписиУчетногоДокумента(ЭтотОбъект, Отказ);
	// Конец ЭлектронноеВзаимодействие.ЭлектронноеАктированиеЕИС
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
