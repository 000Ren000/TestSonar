﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Подсистема "Новости".
// ОбщийМодуль.ОбработкаНовостейКлиентСерверПереопределяемый.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область ИнтерфейсныеОбработчики

// Метод вызывается после создания подменю "Новости" для отображения контекстных новостей.
//
// Параметры:
//  Форма                  - ФормаКлиентскогоПриложения - форма;
//  ЭлементКоманднаяПанель - ЭлементФормы - командная панель, в конце которой будет размещено подменю "Новости";
//  ЭлементПодменюНовости  - ЭлементФормы - созданное подменю;
//  ТаблицаНовостей        - ТаблицаЗначений - таблица значений, в которой должны быть колонки:
//    * Новость              - СправочникСсылка.Новости - ссылка на новость;
//    * НовостьНаименование  - Строка - наименование;
//    * ДатаПубликации       - Дата - дата публикации новости;
//    * Важность             - Число - показатель важности;
//    * ЭтоПостояннаяНовость - Булево - показатель "постоянной" новости.
//
//@skip-warning
Процедура ПослеДобавленияПодменюПросмотраСпискаНовостей(
			Форма,
			ЭлементКоманднаяПанель,
			ЭлементПодменюНовости,
			ТаблицаНовостей) Экспорт

КонецПроцедуры

// Метод вызывается после создания кнопки "Новости" для отображения списка контекстных новостей.
// Здесь можно изменить внешний вид созданной кнопки новостей, например вывести в заголовок количество новостей.
// Примечание: таблица новостей может быть еще НЕ рассчитана (например, если выбрана стратегия расчета в ПриОткрытии),
//  поэтому количество новостей будет = 0, хотя реально новости есть.
// В таблице новостей могут храниться одинаковые новости, но привязанные к разным формам / событиям.
// Поэтому необходимо вывести не общее количество строк, а количество уникальных новостей:
// СписокДобавленныхНовостей = Новый СписокЗначений;
// Для Каждого ТекущаяНовость Из ТаблицаНовостей Цикл
//	Если СписокДобавленныхНовостей.НайтиПоЗначению(ТекущаяНовость.Новость) = Неопределено Тогда
//		СписокДобавленныхНовостей.Добавить(ТекущаяНовость.Новость);
//	КонецЕсли;
// КонецЦикла;
//
// КоличествоНовостей = СписокДобавленныхНовостей.Количество(); // Количество важных + очень важных, вне зависимости от признака прочтенности.
// Если КоличествоНовостей > 0 Тогда
//	КнопкаНовостей.Заголовок = "Новости (" + КоличествоНовостей + ")";
//	//КомандаНовость.Заголовок = "Новости (" + КоличествоНовостей + ")";
// Иначе
//	//КомандаНовость.Заголовок = "Новости";
// КонецЕсли;
//
// Параметры:
//  Форма                  - ФормаКлиентскогоПриложения - форма;
//  ЭлементКоманднаяПанель - ЭлементФормы - командная панель, в конце которой будет размещена кнопка "Новости";
//  КнопкаНовостей         - ЭлементФормы - созданная кнопка;
//  ТаблицаНовостей        - ТаблицаЗначений - таблица значений, в которой должны быть колонки:
//    * Новость              - СправочникСсылка.Новости - ссылка на новость;
//    * НовостьНаименование  - Строка - наименование;
//    * ДатаПубликации       - Дата - дата публикации новости;
//    * Важность             - Число - показатель важности;
//    * ЭтоПостояннаяНовость - Булево - показатель "постоянной" новости.
//
//@skip-warning
Процедура ПослеДобавленияКнопкиПросмотраСпискаНовостей(
			Форма,
			ЭлементКоманднаяПанель,
			КнопкаНовостей,
			ТаблицаНовостей) Экспорт

КонецПроцедуры

// Метод переопределяет количество элементов подменю "Новости" для блока "Постоянные новости", т.е. сколько последних
//   новостей надо вывести в этот блок подменю.
// Разработчик конфигурации может поменять это количество.
// 
// Параметры:
//  ТекущееЗначение - Число - количество элементов подменю "Новости" для блока "Постоянные новости".
//
// Возвращаемое значение:
//  Число.
//
//@skip-warning
Процедура ПереопределитьРазмерПодменюПостоянныхКонтекстныхНовостей(ТекущееЗначение = 5) Экспорт

КонецПроцедуры

// Метод переопределяет количество элементов подменю "Новости" для блока "Новости", т.е. сколько последних
//   новостей надо вывести в этот блок подменю.
// Разработчик конфигурации может поменять это количество.
// 
// Параметры:
//  ТекущееЗначение - Число - количество элементов подменю "Новости" для блока "Новости".
//
// Возвращаемое значение:
//  Число.
//
//@skip-warning
Процедура ПереопределитьРазмерПодменюКонтекстныхНовостей(ТекущееЗначение = 10) Экспорт

КонецПроцедуры

// Метод переопределяет интервал (в секундах), после которого в формах надо подключать обработчик получения новостей.
// Время не должно быть меньше 0,5 секунды.
// 
// Параметры:
//  ТекущееЗначение - Число - число секунд, после которого должны подключаться обработчики событий.
//
// Возвращаемое значение:
//  Число.
//
//@skip-warning
Процедура ПереопределитьИнтервалПодключенияОбработчикаПроверкиКонтекстныхНовостей(ТекущееЗначение = 0.5) Экспорт

КонецПроцедуры

#КонецОбласти

#Область ПанельКонтекстныхНовостей

// В этой процедуре можно переопределить процедуру показа списка новостей для панели контекстных новостей.
// Массив структур новостей для отображения хранится в Форма.Новости.НовостиДляПанелиКонтекстныхНовостей.
// СпособОтображенияПанелиКонтекстныхНовостей хранится в Форма.Новости.СпособОтображенияПанелиКонтекстныхНовостей.
//
// Параметры:
//  Форма                - ФормаКлиентскогоПриложения - форма объекта с панелью важных новостей;
//  СтандартнаяОбработка - Булево - В данный параметр передается признак выполнения стандартной (библиотечной) обработки события.
//
//@skip-warning
Процедура ПанельКонтекстныхНовостей_ОтобразитьНовости(Форма, СтандартнаяОбработка) Экспорт

КонецПроцедуры

#КонецОбласти

#КонецОбласти

