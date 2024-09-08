﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Добавляет команду создания объекта.
//
// Параметры:
//  КомандыСозданияНаОсновании - ТаблицаЗначений - таблица команд.
// Возвращаемое значение:
//  СтрокаТаблицыЗначений, Неопределено - описание добавленной команды.
Функция ДобавитьКомандуСоздатьНаОснованииСнятиеРезерва(КомандыСозданияНаОсновании) Экспорт
	Если ПравоДоступа("Добавление", Метаданные.Документы.КорректировкаНазначенияТоваров) Тогда
		КомандаСоздатьНаОсновании = КомандыСозданияНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Менеджер = Метаданные.Обработки.ЗаполнениеКорректировкиНазначения.ПолноеИмя();
		КомандаСоздатьНаОсновании.Обработчик = "СозданиеНаОснованииУТКлиент.ОткрытьМастерСнятияРезерва";
		КомандаСоздатьНаОсновании.Представление = НСтр("ru = 'Корректировка назначения товаров (снятие резерва)'");
		КомандаСоздатьНаОсновании.РежимЗаписи = "Проводить";
		
		Возврат КомандаСоздатьНаОсновании;
	КонецЕсли;
	
	Возврат Неопределено;
КонецФункции

// Добавляет команду создания объекта.
//
// Параметры:
//  КомандыСозданияНаОсновании - ТаблицаЗначений - таблица команд.
// Возвращаемое значение:
//  СтрокаТаблицыЗначений, Неопределено - описание добавленной команды.
Функция ДобавитьКомандуСоздатьНаОснованииРезервирование(КомандыСозданияНаОсновании) Экспорт
	Если ПравоДоступа("Добавление", Метаданные.Документы.КорректировкаНазначенияТоваров) Тогда
		КомандаСоздатьНаОсновании = КомандыСозданияНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Менеджер = Метаданные.Обработки.ЗаполнениеКорректировкиНазначения.ПолноеИмя();
		КомандаСоздатьНаОсновании.Обработчик = "СозданиеНаОснованииУТКлиент.ОткрытьМастерРезервирования";
		КомандаСоздатьНаОсновании.Представление = НСтр("ru = 'Корректировка назначения товаров (резервирование)'");
		КомандаСоздатьНаОсновании.РежимЗаписи = "Проводить";
		
		Возврат КомандаСоздатьНаОсновании;
	КонецЕсли;
	
	Возврат Неопределено;
КонецФункции

// Конструктор параметров формы заполнения корректировки назначения.
// Возвращаемое значение:
//  Структура - структура с полями:
//   * Мастер - Булево - истина, при закрытии формы заполнения будет создан документ,
//              Ложь - в результате товары для заполнения будут помещены во временное хранилище.
//   * ВидОперации - ПеречислениеСсылка.ВидыОперацийКорректировкиНазначения - вид операции.
//   * Назначение - СправочникСсылка.Назначения - назначение для которого необходимо заполнить документ.
//   * Заказ - ДокументСсылка - заказ в контексте которого вызывают заполнение.
//   * Организация - СправочникСсылка.СтруктураПредприятия - используется для отбора остатков под назначения заказов заданной организации.
//   * АдресТоваров - Строка - адрес хранилища с таблицей отбора товаров.
//   * КорректировкаНазначения - ДокументСсылка.КорректировкаНазначенияТоваров - ссылка на перезаполняемый документ, который ранее мог быть уже проведен.
//   * Количество - Число - используется в операции встречная корректировка.
Функция ПараметрыФормы() Экспорт
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("Мастер",                  Ложь);
	ПараметрыФормы.Вставить("ВидОперации",             Неопределено);
	ПараметрыФормы.Вставить("Назначение",              Неопределено);
	ПараметрыФормы.Вставить("Заказ",                   Неопределено);
	ПараметрыФормы.Вставить("Организация",             Неопределено);
	ПараметрыФормы.Вставить("АдресТоваров",            Неопределено);
	ПараметрыФормы.Вставить("КорректировкаНазначения", Неопределено);
	ПараметрыФормы.Вставить("Количество",              Неопределено);

	Возврат ПараметрыФормы;
		
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Функция СоздатьДокументыВФоне(ПараметрыПроцедуры) Экспорт
	
	СписокДокументов = Новый Массив();
	
	ТоварыКПереносу = ПараметрыПроцедуры.ТоварыКПереносу;
	СтрокаТаблицы = Неопределено;
	НовоеНазначение = Неопределено;
	ТекущиеТовары = ТоварыКПереносу.СкопироватьКолонки();
	Ошибки = Новый массив();
	Для Индекс = 0 По ТоварыКПереносу.Количество() Цикл
		
		Если Индекс < ТоварыКПереносу.Количество() Тогда
			СтрокаТаблицы = ТоварыКПереносу[Индекс];
		КонецЕсли;
		
		Если Индекс = ТоварыКПереносу.Количество()
			Или СтрокаТаблицы.НовоеНазначение <> НовоеНазначение Тогда
				
				Если НовоеНазначение <> Неопределено Тогда
					
					РеквизитыШапки = Новый Структура("ВидОперации,Организация,Назначение");
					ЗаполнитьЗначенияСвойств(РеквизитыШапки, ПараметрыПроцедуры);
					РеквизитыШапки.Назначение = НовоеНазначение;
					РезультатСозданияДокумента = Документы.КорректировкаНазначенияТоваров.СоздатьЗаполнитьИПровестиДокумент(
						РеквизитыШапки,
						ТекущиеТовары);
					СписокДокументов.Добавить(РезультатСозданияДокумента.Документ);
					Если Не РезультатСозданияДокумента.Проведен Тогда
						ОшибкиДокумента = Новый Структура("Ошибки,Документ");
						ЗаполнитьЗначенияСвойств(ОшибкиДокумента, РезультатСозданияДокумента);
						Ошибки.Добавить(ОшибкиДокумента);
					КонецЕсли;
					
				КонецЕсли;
				
				ТекущиеТовары.Очистить();
				Если Индекс < ТоварыКПереносу.Количество() Тогда
					НовоеНазначение = СтрокаТаблицы.НовоеНазначение;
				КонецЕсли;
				
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(ТекущиеТовары.Добавить(), СтрокаТаблицы);
		
	КонецЦикла;
	ОбеспечениеВДокументахСервер.ПроверитьЗапуститьФоновоеЗаданиеРаспределенияЗапасов();
	Результат = Новый Структура("Документы,Ошибки", СписокДокументов, Ошибки);
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецЕсли
