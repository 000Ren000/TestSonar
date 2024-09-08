﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	СтарыйСтатус = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "Статус");
	СтатусИзменился = Статус <> СтарыйСтатус;
	Если Не ЭтоНовый() И СтатусИзменился Тогда
		КонтекстДиагностики = Неопределено;
		ДополнительныеСвойства.Свойство("КонтекстДиагностики", КонтекстДиагностики);
		СинхронизацияЭДОСобытия.ПриИзмененииСтатусаТранспортногоКонтейнера(Ссылка, Статус, КонтекстДиагностики);
		ДополнительныеСвойства.Вставить("КонтекстДиагностики", КонтекстДиагностики);
	КонецЕсли;
	Статусы = ТранспортныеКонтейнерыЭДОСлужебный.СтатусыОбработанногоКонтейнера();
	Если Статусы.Найти(Статус) <> Неопределено Тогда
		
		Если СтатусИзменился Тогда
			// Фиксируем момент времени, для того чтобы в будущем пометить контейнер на удаление как обработанный.
			// Срок хранения контейнеров в днях определен в константе "СрокХраненияТранспортногоКонтейнераЭДО".
			ДатаОбработки = ТекущаяДатаСеанса();
		КонецЕсли;
		
	КонецЕсли;
	
	ЗаполнитьИсториюОбработки();
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ТранспортныйКонтейнерЭДОПрисоединенныеФайлы.ВладелецФайла КАК ВладелецФайла,
	|	ТранспортныйКонтейнерЭДОПрисоединенныеФайлы.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ТранспортныйКонтейнерЭДОПрисоединенныеФайлы КАК ТранспортныйКонтейнерЭДОПрисоединенныеФайлы
	|ГДЕ
	|	ТранспортныйКонтейнерЭДОПрисоединенныеФайлы.ВладелецФайла = &ВладелецФайла";
	Запрос.УстановитьПараметр("ВладелецФайла", Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ПоляБлокировки = Новый Структура("ВладелецФайла, Ссылка", "ВладелецФайла", "Ссылка");
	
	ОбщегоНазначенияБЭД.УстановитьУправляемуюБлокировку(
		"Справочник.ТранспортныйКонтейнерЭДОПрисоединенныеФайлы",
		ПоляБлокировки,
		РезультатЗапроса);
	
	Результат = РезультатЗапроса.Выбрать();
	
	Пока Результат.Следующий() Цикл
		Объект = Результат.Ссылка.ПолучитьОбъект();
		Если Не Объект.ПометкаУдаления = ПометкаУдаления Тогда 
			Объект.ПометкаУдаления = ПометкаУдаления;
			Объект.Записать();
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьИсториюОбработки() 
	
	СтатусыПолучен = Новый Массив;
	СтатусыРаспакован = Новый Массив;
	СтатусыПодготовлен = Новый Массив;
	СтатусыОтправлен = Новый Массив;
	
	ДатаСеанса = ТекущаяДатаСеанса();
	
	СтатусыРаспакован.Добавить(Перечисления.СтатусыТранспортныхСообщенийБЭД.Распакован);
	СтатусыРаспакован.Добавить(Перечисления.СтатусыТранспортныхСообщенийБЭД.РаспакованДокументыНеОбработаны);
	
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(СтатусыПолучен, СтатусыРаспакован);
	СтатусыПолучен.Добавить(Перечисления.СтатусыТранспортныхСообщенийБЭД.КРаспаковке);

	СтатусыОтправлен.Добавить(Перечисления.СтатусыТранспортныхСообщенийБЭД.Отправлен);
	СтатусыОтправлен.Добавить(Перечисления.СтатусыТранспортныхСообщенийБЭД.Доставлен);
	
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(СтатусыПодготовлен, СтатусыОтправлен);
	СтатусыПодготовлен.Добавить(Перечисления.СтатусыТранспортныхСообщенийБЭД.ПодготовленКОтправке);
	
	Если Не ЗначениеЗаполнено(ДатаПолучения)
		И СтатусыПолучен.Найти(Статус) <> Неопределено Тогда
		ДатаПолучения = ДатаСеанса;
	КонецЕсли;
	Если Не ЗначениеЗаполнено(ДатаРаспаковки)
		И СтатусыРаспакован.Найти(Статус) <> Неопределено Тогда
		ДатаРаспаковки = ДатаСеанса;
	КонецЕсли;
	Если Не ЗначениеЗаполнено(ДатаПодготовки)
		И СтатусыПодготовлен.Найти(Статус) <> Неопределено Тогда
		ДатаПодготовки = ДатаСеанса;
	КонецЕсли;
	Если Не ЗначениеЗаполнено(ДатаОтправки)
		И СтатусыОтправлен.Найти(Статус) <> Неопределено Тогда
		ДатаОтправки = ДатаСеанса;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Иначе
	
	ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
	
#КонецЕсли
