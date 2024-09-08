﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;	
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если Бессрочный Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ДатаОкончанияСрокаДействия");
	КонецЕсли;
	
	МассивНепроверяемыхРеквизитов.Добавить("Наименование");

	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	НоменклатураЛокализация.ПриКопировании_СертификатыНоменклатуры(ЭтотОбъект, ОбъектКопирования);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЭтоГруппа
		И Не Бессрочный
		И ДатаОкончанияСрокаДействия < ДатаНачалаСрокаДействия Тогда
		ДатаОкончанияСрокаДействия = ДатаНачалаСрокаДействия;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#КонецЕсли