﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область СлужебныйПрограммныйИнтерфейс

Функция Значение() Экспорт
	
	ТекущееЗначение = Получить();
	Если ТекущееЗначение = 0 Тогда
		Возврат 1024;
	Иначе
		Возврат ТекущееЗначение;
	КонецЕсли;
	
КонецФункции

#КонецОбласти
	
#КонецЕсли