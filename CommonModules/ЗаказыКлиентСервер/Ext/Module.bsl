﻿#Область ПрограммныйИнтерфейс

#Область СтруктураДействий

// Добавляет действие "ЗаполнитьПризнакРасхождениеЗаказ" в структуру действий
//
// Параметры:
//  СтруктураДействий - Структура - структура действий
//  ПоЗаказам         - Булево    -
// 
Процедура ДобавитьДействиеЗаполнитьПризнакРасхождениеЗаказ(СтруктураДействий, ПоЗаказам) Экспорт
	
	Если Не ПоЗаказам Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураДействий.Вставить(
		"ЗаполнитьПризнакРасхождениеЗаказ", ПараметрыЗаполненияПризнакРасхождениеЗаказ(ПоЗаказам));
	
КонецПроцедуры

//Возвращает параметры заполнения признака "РасхождениеЗаказ"
//
// Параметры:
//  ПоЗаказам - Булево -
//
// Возвращаемое значение:
//  Структура - содержит:
//               *ПоЗаказам - Булево -
//
Функция ПараметрыЗаполненияПризнакРасхождениеЗаказ(ПоЗаказам) Экспорт

	Возврат Новый Структура("ПоЗаказам", ПоЗаказам);

КонецФункции

#КонецОбласти

#КонецОбласти