﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

Функция ПолучитьИндексКартинки(ЗначениеПеречисления) Экспорт
	
	Если ЗначениеПеречисления = ОжидаетсяПодключение Тогда
		Индекс = 3;
	ИначеЕсли ЗначениеПеречисления = Подключен Тогда
		Индекс = 0;
	ИначеЕсли ЗначениеПеречисления = Приостановлен Тогда
		Индекс = 2;
	ИначеЕсли ЗначениеПеречисления = Недоступен Тогда
		Индекс = 4;
	Иначе
		// Черновик, пустая ссылка, не подключено
		Индекс = 1;
	КонецЕсли;
	
	Возврат Индекс;
	
КонецФункции

#КонецОбласти	
	
#КонецЕсли