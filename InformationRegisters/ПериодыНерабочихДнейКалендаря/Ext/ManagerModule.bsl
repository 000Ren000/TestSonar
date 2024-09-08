﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Функция ПериодыНерабочихДней(ПроизводственныйКалендарь) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ПроизводственныйКалендарь", ПроизводственныйКалендарь);
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПериодыНерабочихДнейКалендаря.ПроизводственныйКалендарь КАК ПроизводственныйКалендарь,
		|	ПериодыНерабочихДнейКалендаря.НомерПериода КАК НомерПериода,
		|	ПериодыНерабочихДнейКалендаря.ДатаНачала КАК ДатаНачала,
		|	ПериодыНерабочихДнейКалендаря.ДатаОкончания КАК ДатаОкончания,
		|	ПериодыНерабочихДнейКалендаря.Основание КАК Основание
		|ИЗ
		|	РегистрСведений.ПериодыНерабочихДнейКалендаря КАК ПериодыНерабочихДнейКалендаря
		|ГДЕ
		|	ПериодыНерабочихДнейКалендаря.ПроизводственныйКалендарь = &ПроизводственныйКалендарь
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерПериода";
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

#КонецОбласти

#КонецЕсли	