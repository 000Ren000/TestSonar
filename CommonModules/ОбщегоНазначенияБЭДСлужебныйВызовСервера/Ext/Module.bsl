﻿#Область СлужебныеПроцедурыИФункции

Функция ИмяОбъектаМетаданных(Тип) Экспорт
	ОбъектМетаданных = Метаданные.НайтиПоТипу(Тип);
	Если ОбъектМетаданных = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	Возврат ОбъектМетаданных.Имя;
КонецФункции

Функция ИмяПрикладногоСправочника(ИмяСправочника) Экспорт
	
	Возврат ОбщегоНазначенияБЭД.ИмяПрикладногоСправочника(ИмяСправочника);
	
КонецФункции

Функция ПолучитьПараметрРегламентногоЗадания(ИмяЗадания, ИмяПараметра, ЗначениеПоУмолчанию) Экспорт
	
	// Проверка отсутствие поставляемого регламентного задания в конфигурации.
	РегламентноеЗадание = Метаданные.РегламентныеЗадания[ИмяЗадания];
	Если РегламентноеЗадание = Неопределено Тогда
		Возврат ЗначениеПоУмолчанию;
	КонецЕсли;
	
	// Поиск задания.
	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("Метаданные", РегламентноеЗадание);
	Если Не ОбщегоНазначения.РазделениеВключено() Тогда
		ПараметрыЗадания.Вставить("ИмяМетода", РегламентноеЗадание.ИмяМетода);
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	СписокЗаданий = РегламентныеЗаданияСервер.НайтиЗадания(ПараметрыЗадания);
	Если СписокЗаданий.Количество() Тогда
		Возврат СписокЗаданий[0][ИмяПараметра];
	Иначе
		Возврат ЗначениеПоУмолчанию;
	КонецЕсли;
	
КонецФункции

Процедура ИзменитьРасписаниеЗадания(ИмяЗадания, РасписаниеРегламентногоЗадания) Экспорт
	
	ИдентификаторЗадания = ОбщегоНазначенияБЭД.РегламентноеЗаданиеПоНаименованию(ИмяЗадания);
	РегламентныеЗаданияСервер.УстановитьРасписаниеРегламентногоЗадания(ИдентификаторЗадания, РасписаниеРегламентногоЗадания);
	
КонецПроцедуры

#КонецОбласти