﻿
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗагрузитьПерезаполнитьИзФайла(Команда)
	
	ОбработчикЗавершения = Новый ОписаниеОповещения("ЗагрузитьПерезаполнитьИзФайлаЗавершение", ЭтотОбъект);
	ПараметрыЗагрузки = ФайловаяСистемаКлиент.ПараметрыЗагрузкиФайла();
	ПараметрыЗагрузки.ИдентификаторФормы = УникальныйИдентификатор;
	ПараметрыЗагрузки.Диалог.Фильтр = НСтр("ru = 'Архив'") + " (*.zip)|*.zip";
	ПараметрыЗагрузки.Диалог.Заголовок = НСтр("ru = 'Выберите архив с доверенностью и подписью'");
	ФайловаяСистемаКлиент.ЗагрузитьФайл(ОбработчикЗавершения, ПараметрыЗагрузки);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Загружает МЧД в базу из полученного архива
// 
// Параметры:
//  ПомещенныйФайл - Неопределено
//                 - Структура:
//                   * Хранение - Строка
//                   * Имя - Строка
//  ДополнительныеПараметры - Структура
&НаКлиенте
Процедура ЗагрузитьПерезаполнитьИзФайлаЗавершение(ПомещенныйФайл, ДополнительныеПараметры) Экспорт
	
	Если ПомещенныйФайл = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	АдресВоВременномХранилище = ПомещенныйФайл.Хранение;
	МашиночитаемыеДоверенностиКлиент.ЗагрузитьПерезаполнитьМЧДИзФайла(
		АдресВоВременномХранилище);
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

#КонецОбласти