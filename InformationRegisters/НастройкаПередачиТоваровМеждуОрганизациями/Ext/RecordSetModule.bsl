﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	СтруктураПроверки = Справочники.Организации.СтраныРегистрацииИВалютыРегламентированногоУчетаСовпадают(
								Отбор.ОрганизацияВладелец.Значение, Отбор.ОрганизацияПродавец.Значение);
	
	Если Не СтруктураПроверки.ВалютыСовпадают Тогда
		ТекстОшибки = НСтр("ru = 'Валюты регламентированного учета владельца %1 и продавца %2 должны совпадать.'");
		ТекстОшибки = СтрШаблон(ТекстОшибки, Отбор.ОрганизацияВладелец.Значение, Отбор.ОрганизацияПродавец.Значение);
		ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, , "ОрганизацияВладелец",, Отказ);
	КонецЕсли;
	
	Если Не СтруктураПроверки.СтраныСовпадают Тогда
		ТекстОшибки = НСтр("ru = 'Страны регистрации владельца %1 и продавца %2 должны совпадать.'");
		ТекстОшибки = СтрШаблон(ТекстОшибки, Отбор.ОрганизацияВладелец.Значение, Отбор.ОрганизацияПродавец.Значение);
		ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, , "ОрганизацияВладелец",, Отказ);
	КонецЕсли;
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если ЭтотОбъект[0].СпособПередачиТоваров <> Перечисления.СпособыПередачиТоваров.ПередачаНаКомиссию Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Валюта");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(
		ПроверяемыеРеквизиты,
		МассивНепроверяемыхРеквизитов);
КонецПроцедуры

#КонецОбласти

#КонецЕсли
