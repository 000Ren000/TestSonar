﻿#Область ПрограммныйИнтерфейс

#Область Локализация

// Переопределение параметров интеграции САТУРН (расположения форматированной строки)
//
// Параметры:
//   Форма            - ФормаКлиентскогоПриложения - прикладная форма для встраивания форматированной строки
//   ПараметрыНадписи - см. СобытияФормИС.ПараметрыИнтеграцииДляДокументаОснования
Процедура ПриОпределенииПараметровИнтеграцииСАТУРН(Форма, ПараметрыНадписи) Экспорт
	
	Возврат;
	
КонецПроцедуры

Процедура ПослеЗаписиНаСервере(Форма) Экспорт
	
	Возврат;
	
КонецПроцедуры

Процедура ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт
	
	Возврат;
	
КонецПроцедуры

Процедура ПриЧтенииНаСервере(Форма, ТекущийОбъект) Экспорт
	
	Возврат;
	
КонецПроцедуры

#Область СобытияЭлементовФорм

// Серверная переопределяемая процедура, вызываемая из обработчика события элемента.
//
// Параметры:
//   Форма                   - ФормаКлиентскогоПриложения - форма, из которой происходит вызов процедуры.
//   Элемент                 - Строка           - имя элемента-источника события "При изменении"
//   ДополнительныеПараметры - Структура        - значения дополнительных параметров влияющих на обработку.
//
Процедура ПриИзмененииЭлемента(Форма, Элемент, ДополнительныеПараметры) Экспорт
	
	//++ НЕ ГОСИС
	//-- НЕ ГОСИС
	Возврат;
	
КонецПроцедуры

#КонецОбласти

// Заполняет табличную часть подобранными товарами.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма, в которой производится подбор,
//  ВыбранноеЗначение - Произвольный - данные, содержащие подобранную пользователем номенклатуру,
//  ПараметрыЗаполнения - Структура - дополнительные параметры заполнения
//  ПараметрыЗаполнения - Структура - параметры заполнения,
//  КэшированныеЗначения - Неопределено, Структура - сохраненные значения параметров, используемых при обработке,
//  ДобавленныеСтроки - Неопределено, Массив из ДанныеФормыЭлементКоллекции - массив добавленных строк таблицы товаров
Процедура ОбработкаРезультатаПодбораНоменклатуры(
	Форма, ВыбранноеЗначение, ПараметрыЗаполнения,
	КэшированныеЗначения = Неопределено, ДобавленныеСтроки = Неопределено) Экспорт
	
	//++ НЕ ГОСИС
	
	Если ВыбранноеЗначение = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТаблицаТоваров = ПолучитьИзВременногоХранилища(ВыбранноеЗначение.АдресТоваровВХранилище);
	
	ИспользуютсяУпаковки = Истина;
	Если ПараметрыЗаполнения.Свойство("ИспользуютсяУпаковки") Тогда
		ИспользуютсяУпаковки = ПараметрыЗаполнения.ИспользуютсяУпаковки;
	КонецЕсли;
	
	ПараметрыУказанияСерий = Неопределено;
	ПараметрыЗаполнения.Свойство("ПараметрыУказанияСерий", ПараметрыУказанияСерий);
	
	ИмяТабличнойЧасти = Неопределено;
	Если НЕ ПараметрыЗаполнения.Свойство("ИмяТабличнойЧасти", ИмяТабличнойЧасти) Тогда
		ИмяТабличнойЧасти = "Товары";
	КонецЕсли;
	
	ТекущаяСтрока = Неопределено;
	
	Для каждого СтрокаТовара Из ТаблицаТоваров Цикл
		
		Если Не ИспользуютсяУпаковки Тогда
			СтрокаТовара.КоличествоУпаковок = СтрокаТовара.Количество;
			СтрокаТовара.Упаковка = Неопределено;
		КонецЕсли;
		
		ТекущаяСтрока = Форма.Объект[ИмяТабличнойЧасти].Добавить();
		
		ЗаполнитьЗначенияСвойств(ТекущаяСтрока, СтрокаТовара);
		
		Если ДобавленныеСтроки <> Неопределено Тогда
			ДобавленныеСтроки.Добавить(ТекущаяСтрока);
		КонецЕсли;
		
	КонецЦикла;
	
	Если ТекущаяСтрока <> Неопределено Тогда
		Форма.Элементы[ИмяТабличнойЧасти].ТекущаяСтрока = ТекущаяСтрока.ПолучитьИдентификатор();
	КонецЕсли;
	
	//-- НЕ ГОСИС
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
