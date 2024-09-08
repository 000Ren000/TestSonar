﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Значение) Тогда
		Отказ = Истина;
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Значение не должно иметь пустое значение'"));
	КонецЕсли;
	
	Если Значение = Перечисления.ТипыПодписиКриптографии.АрхивнаяCAdESAv3 Тогда
		Отказ = Истина;
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Значение не должно иметь значение ""Архивная""'"));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли