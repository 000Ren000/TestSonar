﻿////////////////////////////////////////////////////////////////////////////////
// Модуль "НаправленияДеятельностиКлиентСервер" содержит процедуры,
// связанные с интерактивной работой пользователя в формах документов.
// 
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Устарело. Необходимо использовать НазначенияКлиентСервер.СтруктураДействийВставитьПриДобавленииСтроки
// Предназначена для использования в формах документах в обработчиках событий, которые приводят к изменению назначения в
// строке табличной части документа. Добавляет в структуру действий действие, которое отрабатывается механизмами
// обработки табличных частей (см. ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ) Выполнение такого
// действия актуализирует назначение в строке табличной части документа, в соответствии с изменившимся направлением деятельности.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - Форма в которой необходимо выполнить действие по обработки строки табличной части.
//  СтруктураДействий - Структура - Структура действий, используемая механизмами обработки табличных частей (см. ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ).
//
Процедура СтруктураДействийВставитьПриДобавленииСтроки(Форма, СтруктураДействий) Экспорт
	
	НазначенияКлиентСервер.СтруктураДействийВставитьПриДобавленииСтроки(Форма, СтруктураДействий, Истина);
	
КонецПроцедуры

// Устарело. Необходимо использовать НазначенияКлиентСервер.ЗаполнитьНазначениеПоФлагуОбособленно
// Заполняет невидимое поле Назначение в документах исходя из заполненного поля Обособленно.
// 
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - Форма в которой необходимо выполнить действие по обработки строки табличной части.
//  ТекущаяСтрока - ДанныеФормыЭлементКоллекции - строка в которой нужно заполнить назначение исходя из флага Обособленно.
//
Процедура ЗаполнитьНазначениеПоФлагуОбособленно(Форма, ТекущаяСтрока) Экспорт
	
	НазначенияКлиентСервер.ЗаполнитьНазначениеПоФлагуОбособленно(Форма, ТекущаяСтрока, Истина);
	
КонецПроцедуры

#КонецОбласти

