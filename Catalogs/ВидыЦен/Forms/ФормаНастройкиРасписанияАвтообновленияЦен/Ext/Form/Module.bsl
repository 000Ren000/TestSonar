﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	РазделениеВключено = ОбщегоНазначения.РазделениеВключено();

	Если НЕ РазрешеноИзменение() Тогда
		Элементы.ТаблицаРегламентныеЗадания.ТолькоПросмотр = Истина;
		Элементы.ТаблицаРегламентныеЗаданияНастроитьРасписание.Доступность = Ложь;
	КонецЕсли;
	
	Элементы.ТаблицаРегламентныеЗаданияНастроитьРасписание.Видимость = Не РазделениеВключено;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ЗагрузитьРегламентныеЗадания();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_РегламентныеЗадания" Тогда
		
		ЗагрузитьРегламентныеЗадания(Параметр);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТаблицаРегламентныеЗадания
&НаКлиенте
Процедура ТаблицаРегламентныеЗаданияПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, ЭтоГруппа, Параметр)
	Отказ = Истина;
	
	ДобавитьСкопироватьИзменитьРегламентноеЗадание(?(Копирование, "Скопировать", "Добавить"));
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаРегламентныеЗаданияПередНачаломИзменения(Элемент, Отказ)
	Отказ = Истина;
	Если РазрешеноИзменение() Тогда
		ДобавитьСкопироватьИзменитьРегламентноеЗадание("Изменить");
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаРегламентныеЗаданияПередУдалением(Элемент, Отказ)
	Отказ = Истина;
	
	Если Элементы.ТаблицаРегламентныеЗадания.ВыделенныеСтроки.Количество() > 1 Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Выберите одно регламентное задание.'"));
		
	ИначеЕсли Элемент.ТекущиеДанные.Предопределенное Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Невозможно удалить предопределенное регламентное задание.'") );
	Иначе
		ПоказатьВопрос(
			Новый ОписаниеОповещения("ТаблицаРегламентныеЗаданияПередУдалениемЗавершение", ЭтотОбъект),
			НСтр("ru = 'Удалить регламентное задание?'"), РежимДиалогаВопрос.ДаНет);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьСкопироватьИзменитьРегламентноеЗадание(Знач Действие)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Действие",      Действие);
	
	Если Не Элементы.ТаблицаРегламентныеЗадания.ТекущиеДанные = Неопределено Тогда
		ПараметрыФормы.Вставить("Идентификатор", Элементы.ТаблицаРегламентныеЗадания.ТекущиеДанные.Идентификатор);
	КонецЕсли;

	ОткрытьФорму("Справочник.ВидыЦен.Форма.РегламентноеЗаданиеОбновлениеЦен", ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры
#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НастроитьРасписание(Команда)
	ТекущиеДанные = Элементы.ТаблицаРегламентныеЗадания.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Выберите регламентное задание.'"));
	
	ИначеЕсли Элементы.ТаблицаРегламентныеЗадания.ВыделенныеСтроки.Количество() > 1 Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Выберите одно регламентное задание.'"));
	Иначе
		Диалог = Новый ДиалогРасписанияРегламентногоЗадания(
			ПолучитьРасписание(ТекущиеДанные.Идентификатор));
		
		Диалог.Показать(Новый ОписаниеОповещения(
			"ОткрытьРасписаниеЗавершение", ЭтотОбъект, ТекущиеДанные));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьРегламентныеЗадания(Команда)
	
	ЗагрузитьРегламентныеЗадания();

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Процедура УстановитьРасписание(Знач ИдентификаторРегламентногоЗадания, Знач Расписание)
	
	УстановитьПривилегированныйРежим(Истина);
	
	РегламентныеЗаданияСервер.УстановитьРасписаниеРегламентногоЗадания(
		ИдентификаторРегламентногоЗадания,
		Расписание);

	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры


// Установка нового расписания
// 
// Параметры:
// 	НовоеРасписание - РасписаниеРегламентногоЗадания
// 	ТекущиеДанные - ДанныеФормыЭлементКоллекции
&НаКлиенте
Процедура ОткрытьРасписаниеЗавершение(НовоеРасписание, ТекущиеДанные) Экспорт

	Если НовоеРасписание <> Неопределено Тогда

		Если РазделениеВключено 
			И НовоеРасписание.ПериодПовтораВТечениеДня > 0
			И НовоеРасписание.ПериодПовтораВТечениеДня < 3600 Тогда
			
			НовоеРасписание.ПериодПовтораВТечениеДня = 3600;
			
		КонецЕсли;
		
		УстановитьРасписание(ТекущиеДанные.Идентификатор, НовоеРасписание);
		ЗагрузитьРегламентныеЗадания(ТекущиеДанные.Идентификатор);
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьРасписание(Знач ИдентификаторРегламентногоЗадания)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Возврат РегламентныеЗаданияСервер.РасписаниеРегламентногоЗадания(
		ИдентификаторРегламентногоЗадания);
	
КонецФункции

&НаСервере
Функция ЗагрузитьРегламентныеЗадания(ИдентификаторЗадания = Неопределено)

	Таблица =  РеквизитФормыВЗначение("ТаблицаРегламентныеЗадания");

	// Обновление таблицы РегламентныеЗадания и списка СписокВыбора регламентного задания для отбора.
	Если ИдентификаторЗадания = Неопределено Тогда
		Отбор = новый Структура("Метаданные", Метаданные.РегламентныеЗадания.ОбновлениеЦен);
	Иначе	
		Отбор = новый Структура("УникальныйИдентификатор",Новый УникальныйИдентификатор(ИдентификаторЗадания));
	КонецЕсли;	
	
	УстановитьПривилегированныйРежим(Истина);
	ТекущиеЗадания = РегламентныеЗаданияСервер.НайтиЗадания(Отбор);
	УстановитьПривилегированныйРежим(Ложь);
	
	Если ИдентификаторЗадания = Неопределено Тогда
		Индекс = 0;
		Для Каждого Задание Из ТекущиеЗадания Цикл
			
			Идентификатор = Строка(РегламентныеЗаданияСервер.УникальныйИдентификатор(Задание));
			
			Если Индекс >= Таблица.Количество()
			 ИЛИ Таблица[Индекс].Идентификатор <> Идентификатор Тогда
				
				// Вставка нового задания.
				Обновляемое = Таблица.Вставить(Индекс);
			Иначе
				Обновляемое = Таблица[Индекс];
			КонецЕсли;
			
			ЗаполнитьЗначенияСвойств(Обновляемое, Задание);

			Обновляемое.Идентификатор = Идентификатор;
			
			Если ПустаяСтрока(Обновляемое.Наименование) Тогда
				Обновляемое.Наименование = Автонаименование(Задание.Параметры);
			КонецЕсли;
			
			Индекс = Индекс + 1;
		КонецЦикла;
	
		// Удаление лишних строк.
		Пока Индекс < Таблица.Количество() Цикл
			Таблица.Удалить(Индекс);
		КонецЦикла;
	Иначе
		
		Строки = Таблица.НайтиСтроки(
			Новый Структура("Идентификатор", ИдентификаторЗадания));
		
		Если Строки.Количество() > 0 
			И ТекущиеЗадания.Количество() > 0 Тогда
			
			ЗаполнитьЗначенияСвойств(Строки[0], ТекущиеЗадания[0]);
			Строки[0].Идентификатор = ИдентификаторЗадания;
			Если ПустаяСтрока(Строки[0].Наименование) Тогда
				Строки[0].Наименование = Автонаименование(ТекущиеЗадания[0].Параметры);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	ОбработатьРезультат(Новый Структура("Таблица", Таблица));
	
	Возврат Истина ;
	
КонецФункции

&НаСервере
Процедура ОбработатьРезультат(Результат)
	
	ЗначениеВРеквизитФормы(Результат.Таблица, "ТаблицаРегламентныеЗадания");
	
	Элементы.ТаблицаРегламентныеЗадания.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаРегламентныеЗаданияПередУдалениемЗавершение(Ответ, Контекст) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		УдалитьРегламентноеЗаданиеВыполнитьНаСервере(
			Элементы.ТаблицаРегламентныеЗадания.ТекущиеДанные.Идентификатор);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УдалитьРегламентноеЗаданиеВыполнитьНаСервере(Знач Идентификатор)
	
	УстановитьПривилегированныйРежим(Истина);

	РегламентныеЗаданияСервер.УдалитьЗадание(Идентификатор);
	
	ЗагрузитьРегламентныеЗадания();
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция РазрешеноИзменение()
	Возврат ПравоДоступа("Изменение", Метаданные.Справочники.ВидыЦен);
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция АвтоНаименование(Параметры)
	
	СтрокаНаименования = "";
	
	ВариантОбновленияЦен = 0;
	ВидыЦен = Новый Массив();
	
	ВидыЦен.Очистить();;
	
	Если (Параметры.Количество() > 0) Тогда
		
		Для Каждого Строка Из Параметры[0] Цикл
			ВидыЦен.Добавить(Строка.ВидЦены);
		КонецЦикла;
		
		ВариантОбновленияЦен = Параметры[1].ВариантОбновленияЦен;
		
	КонецЕсли;
	
	СтрокаНаименования = НСтр("ru = 'Обновление цен ('");
	
	Если ВариантОбновленияЦен = 0 Тогда
		СтрокаНаименования = СтрокаНаименования + НСтр("ru = 'Все)'");
	ИначеЕсли ВариантОбновленияЦен = 1 Тогда
		СтрокаНаименования = СтрокаНаименования + НСтр("ru = 'Только выбранные)'");
	ИначеЕсли ВариантОбновленияЦен = 2 Тогда
		СтрокаНаименования = СтрокаНаименования + НСтр("ru = 'Выбранные и зависимые)'");
	ИначеЕсли ВариантОбновленияЦен = 3 Тогда
		СтрокаНаименования = СтрокаНаименования + НСтр("ru = 'Все кроме выбранных)'");
	КонецЕсли;
	
	ЭтоПервыйЭлементСписка = Истина;
	Для Каждого ВидЦены Из ВидыЦен Цикл
		СтрокаНаименования = СтрокаНаименования + ?(ЭтоПервыйЭлементСписка," ",", ") + ВидЦены;
		ЭтоПервыйЭлементСписка = Ложь;
	КонецЦикла;
	
	Возврат СтрокаНаименования;
	
КонецФункции

#КонецОбласти