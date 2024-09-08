﻿#Область СлужебныеПроцедурыИФункции

// Возвращает параметры получения данных для настройки связи с контрагентом.
// 
// Возвращаемое значение:
// 	Структура:
// * ОтпечаткиНаКлиенте - см. КриптографияБЭД.ПолучитьОтпечаткиСертификатов
// * Организация - Неопределено
// * Контрагент - Неопределено
// * ИдентификаторОрганизации - Строка
// * ИдентификаторКонтрагента - Строка
// * ПриоритетПодключенные - Булево
Функция НовыеПараметрыПолученияДанныхДляНастройкиСвязиСКонтрагентом() Экспорт
	
	Параметры = Новый Структура;
	Параметры.Вставить("ОтпечаткиСертификатов", Неопределено);
	Параметры.Вставить("Организация", Неопределено);
	Параметры.Вставить("Контрагент", Неопределено);
	Параметры.Вставить("ИдентификаторОрганизации", "");
	Параметры.Вставить("ИдентификаторКонтрагента", "");
	Параметры.Вставить("ПриоритетПодключенные", Ложь);
	
	Возврат Параметры;
	
КонецФункции

Процедура ПослеВыполненияДействийПередИзменениемИспользованияУтверждения(Результат, Контекст) Экспорт
	
	Если Результат = Неопределено Тогда
		ВыполнитьОбработкуОповещения(Контекст.Оповещение, Неопределено);
		Возврат;
	КонецЕсли;
	
	Если Результат.Статус <> "Выполнено" Тогда
		
		Если Результат.Статус = "Ошибка" Тогда
			
			ОбработкаНеисправностейБЭДВызовСервера.ОбработатьОшибку(
				НСтр("ru='Изменение опции ""Отправлять входящие документы на утверждение""'"), 
				ОбщегоНазначенияБЭДКлиентСервер.ПодсистемыБЭД().ОбменСКонтрагентами, Результат.ПодробноеПредставлениеОшибки,
				Результат.КраткоеПредставлениеОшибки);
			
		КонецЕсли;
		
		ВыполнитьОбработкуОповещения(Контекст.Оповещение, Неопределено);
		
		Возврат;
		
	КонецЕсли;
	
	Результат = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
	
	ВыполнитьОбработкуОповещения(Контекст.Оповещение, Результат);
	
КонецПроцедуры

#КонецОбласти