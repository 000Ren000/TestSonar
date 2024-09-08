﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ДополнительныеСвойства.Свойство("КонстантаВычисленаПослеБлокировки") Тогда
		
		ВызватьИсключение НСтр("ru = 'Значение константы ""Использовать управление перемещением обособленных товаров"" должно вычисляться после установки исключительной блокировки'");
		
	КонецЕсли;
	
КонецПроцедуры

#КонецЕсли
