﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(СокрЛП(Значение)) Тогда
		Значение = "0";
	КонецЕсли;
	
КонецПроцедуры


#КонецОбласти

#КонецЕсли
