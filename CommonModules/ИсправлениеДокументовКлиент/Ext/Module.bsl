﻿
#Область ПрограммныйИнтерфейс

// Обработчик события навигационной ссылки.
// 
// Параметры:
// 	Форма - ФормаКлиентскогоПриложения - Форма документа
// 	НавигационнаяСсылкаФорматированнойСтроки - Строка - Навигационная ссылка
// 	СтандартнаяОбработка - Булево - Признак стандартной обработки события
//
Процедура СтрокаИсправлениеОбработкаНавигационныйСсылки(Форма, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка) Экспорт
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "ОткрытьСписокИсправительныхДокументов" Тогда
		
		Объект = Форма.Объект;
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ИсправляемыйДокумент", Объект.ИсправляемыйДокумент);
		ПараметрыФормы.Вставить("ТекущийДокумент", Объект.Ссылка);
		
		ОткрытьФорму("ОбщаяФорма.СписокИсправленийДокумента", ПараметрыФормы, Форма);
		
		СтандартнаяОбработка = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

// Процедура открывает форму исправлений документа
// 
// Параметры:
// 	ИсправляемыйДокумент - ДокументСсылка - Исправляемый документ
// 	ТекущийДокумент - ДокументСсылка - Текущий документ
//
Процедура ОткрытьСписокИсправлений(Знач ИсправляемыйДокумент, Знач ТекущийДокумент) Экспорт
	
	ПараметрыСпискаИсправлений = Новый Структура;
	ПараметрыСпискаИсправлений.Вставить("ИсправляемыйДокумент", ИсправляемыйДокумент);
	ПараметрыСпискаИсправлений.Вставить("ТекущийДокумент", ТекущийДокумент);
		
	ОткрытьФорму("ОбщаяФорма.ИсправленияКорректировок", ПараметрыСпискаИсправлений, ЭтотОбъект);
	
КонецПроцедуры

// Процедура, вызываемая из одноименного обработчика события формы. 
// Производит оповещение о том, что введено исправление документа.
//
// Параметры:
// 	Объект					- ДанныеФормыСтруктура - Данные формы, из обработчика события которой происходит вызов процедуры.
//
Процедура ПослеЗаписи(Объект) Экспорт
	
	Если Объект.Исправление Тогда
		Оповестить("Проведение_Исправление", Объект.ИсправляемыйДокумент, Объект.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

// Процедура, вызываемая из одноименного обработчика события формы. 
// Блокирует изменение документа если введено исправление или документ сторно.
//
// Параметры:
// 	ФормаДокумента			- ФормаКлиентскогоПриложения - форма, из обработчика события которой происходит вызов процедуры.
// 	ИмяСобытия				- Строка - идентификатор сообщения принимающей формой (см. метод Оповестить).
// 	Параметр				- ДокументСсылка - Исправляемый/сторнируемый документ.
// 	Источник				- ДокументСсылка - Исправительный документ или документ сторно.
//
Процедура ОбработкаОповещения(ФормаДокумента, ИмяСобытия, Параметр, Источник) Экспорт
	
	ЭлементИсправление = ФормаДокумента.Элементы.СтрокаИсправление;
	ОтменаСторно = ИмяСобытия = "Запись_Сторно";
	
	Если ИмяСобытия = "Проведение_Сторно" Или ИмяСобытия = "Проведение_Исправление" Или ОтменаСторно Тогда
			Если Параметр = ФормаДокумента.Объект.Ссылка Тогда 
				Объект = ФормаДокумента.Объект;
				
				Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Объект, "ИсправляемыйДокумент") Тогда
					ИсправляемыйДокумент = ?(ЗначениеЗаполнено(Объект.ИсправляемыйДокумент), Объект.ИсправляемыйДокумент, Объект.Ссылка);
				Иначе
					ИсправляемыйДокумент = Объект.Ссылка;
				КонецЕсли;
				ФормаДокумента.СтрокаИсправление = ИсправлениеДокументовВызовСервера.ГиперссылкаИсправленияДокумента(
					ИсправляемыйДокумент, ?(ИмяСобытия = "Проведение_Сторно", Источник, Неопределено));
					
				ВведеноИсправление = ЗначениеЗаполнено(ФормаДокумента.СтрокаИсправление);
				ЭлементИсправление.Видимость = ВведеноИсправление;
				ФормаДокумента.ТолькоПросмотр = ВведеноИсправление И Не ОтменаСторно;
				Если ФормаДокумента.Элементы.Найти("ПодменюСоздатьНаОсновании") <> Неопределено Тогда
					ПодменюСоздатьНаОсновании = ФормаДокумента.Элементы.ПодменюСоздатьНаОсновании; // ГруппаФормы - 
					ПодменюСоздатьНаОсновании.Доступность = НЕ ФормаДокумента.ТолькоПросмотр;
				КонецЕсли;
			КонецЕсли;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти
