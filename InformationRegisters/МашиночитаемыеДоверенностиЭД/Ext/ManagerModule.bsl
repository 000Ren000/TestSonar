﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Добавляет МЧД к подписанному объекту
// 
// Параметры:
//  ПодписанныйОбъект - ОпределяемыйТип.ПодписанныйОбъект - Ссылка на подписанный объект
//  МЧД  - СправочникСсылка.МашиночитаемыеДоверенностиОрганизаций, СправочникСсылка.МашиночитаемыеДоверенностиКонтрагентов - Ссылка на МЧД
//  
Процедура ДобавитьМЧД(ПодписанныйОбъект, МЧД) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	МенеджерЗаписи = РегистрыСведений.МашиночитаемыеДоверенностиЭД.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.ЭлектронныйДокумент = ПодписанныйОбъект;
	МенеджерЗаписи.МЧД = МЧД;
	МенеджерЗаписи.Записать();	
	УстановитьПривилегированныйРежим(Ложь);	
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли