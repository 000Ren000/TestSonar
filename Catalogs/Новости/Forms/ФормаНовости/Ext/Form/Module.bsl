﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОписаниеПеременных

&НаКлиенте
Перем ВсеОповещения;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если ОбработкаНовостейПовтИсп.РазрешенаРаботаСНовостямиТекущемуПользователю() <> Истина Тогда
		Отказ = Истина;
		СтандартнаяОбработка = Ложь;
		Возврат;
	КонецЕсли;

	ТипСтруктура = Тип("Структура");

	ПропуститьЧтениеЗаписьПользовательскихНастроекНовости = Ложь;

	// В конфигурации есть общие реквизиты с разделением и включена ФО РаботаВМоделиСервиса.
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		// Если включено разделение данных, и мы зашли в неразделенном сеансе,
		//  то нельзя устанавливать пользовательские свойства новости.
		// Зашли в конфигурацию под пользователем без разделения (и не вошли в область данных).
		Если ИнтернетПоддержкаПользователей.СеансЗапущенБезРазделителей() Тогда
			Элементы.ГруппаКоманднаяПанель.Видимость = Ложь;
			ПолучитьТекущегоПользователя = Ложь;
			ПропуститьЧтениеЗаписьПользовательскихНастроекНовости = Истина;
		Иначе
			ПолучитьТекущегоПользователя = Истина;
		КонецЕсли;
	Иначе
		ПолучитьТекущегоПользователя = Истина;
	КонецЕсли;

	Если ПолучитьТекущегоПользователя = Истина Тогда
		ПараметрыСеанса_ТекущийПользователь = Пользователи.ТекущийПользователь();
		НастройкиЛентыНовостей = ОбработкаНовостейПовтИсп.ПолучитьНастройкиЛентНовостей(
			ПараметрыСеанса_ТекущийПользователь,
			Объект.ЛентаНовостей);
		Если НастройкиЛентыНовостей.Количество() > 0 Тогда
			НастройкиЛентыНовостей = НастройкиЛентыНовостей[0]; // Из массива взять первое значение.
		КонецЕсли;
	Иначе
		ПараметрыСеанса_ТекущийПользователь = Справочники.Пользователи.ПустаяСсылка();
		НастройкиЛентыНовостей = Неопределено;
	КонецЕсли;

	лкТекущаяУниверсальнаяДата = ТекущаяУниверсальнаяДата();

	// Новости не должны создаваться - только читаться, поэтому если Ключ не заполнен, то форму не открывать.
	Если Параметры.Ключ.Пустая() Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru='В справочнике новостей нельзя создавать новости вручную.
			|Используйте загрузку новостей из лент новостей.'");
		Сообщение.Сообщить();
		Отказ = Истина;
		Возврат;
	КонецЕсли;

	Если ВРег(Параметры.РежимОткрытияОкна) = ВРег("БлокироватьОкноВладельца") Тогда
		РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	Иначе // Все остальные значения
		// По-умолчанию - независимое открытие.
	КонецЕсли;

	ПоказыватьКнопкиЗакрытия = (Параметры.ПоказыватьКнопкиЗакрытия = Истина);

	Если (Параметры.ПоказыватьПанельНавигации = Истина)
			И (ОбработкаНовостейПовтИсп.ЕстьРолиЧтенияНовостей()) Тогда
		Элементы.ГруппаНавигация.Видимость = Истина;
	Иначе
		Элементы.ГруппаНавигация.Видимость = Ложь;
	КонецЕсли;

	// Заполнение реквизитов для новости, требующей прочтения.
	// Если новость важная или очень важная, то признак прочтенности имеет особое значение и означает,
	// что новость больше не должна назойливо всплывать.
	// Поэтому для простой новости прочтенность можно устанавливать уже на этапе создания окна, а для
	//  важных и очень важных новостей - только пользователем.

	// Определить, установлена ли важность для контекстного представления новости?
	УстановленаВажностьДляКонтекстнойНовости = Ложь;
	Если (Объект.ДатаЗавершения = '00010101')
			ИЛИ (Объект.ДатаЗавершения > лкТекущаяУниверсальнаяДата) Тогда
		Для каждого ТекущаяПривязкаКМетаданным Из Объект.ПривязкаКМетаданным Цикл
			// Важность для контекстной новости установлена?
			Если (ТекущаяПривязкаКМетаданным.Важность = 1)
					ИЛИ (ТекущаяПривязкаКМетаданным.Важность = 2) Тогда
				// Дата сброса важности установлена? Сброс важности наступил?
				Если (ТекущаяПривязкаКМетаданным.ДатаСбросаВажности = '00010101')
						ИЛИ (ТекущаяПривязкаКМетаданным.ДатаСбросаВажности > лкТекущаяУниверсальнаяДата) Тогда
					УстановленаВажностьДляКонтекстнойНовости = Истина;
					Прервать;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;

	// Если ДатаСбросаВажности пустая или >= ТекущаяУниверсальнаяДата(), то важность имеет значение, иначе Важность = 0.
	ВажностьНаТекущуюДату = 0;
	Если (Объект.ДатаЗавершения = '00010101')
			ИЛИ (Объект.ДатаЗавершения > лкТекущаяУниверсальнаяДата) Тогда // Новость еще актуальна?
		Если (Объект.ДатаСбросаВажности = '00010101')
				ИЛИ (Объект.ДатаСбросаВажности > лкТекущаяУниверсальнаяДата) Тогда
			ВажностьНаТекущуюДату = Объект.Важность;
		КонецЕсли;
	КонецЕсли;

	ТребуетПрочтения = Ложь;
	// Если способ оповещения ленты новостей через систему взаимодействия, то не выводить галочку "ОповещениеВключено".
	СпособОповещения = Перечисления.СпособыОповещенияПользователяОНовостях.ПоУмолчанию;
	Если ТипЗнч(НастройкиЛентыНовостей) = ТипСтруктура Тогда
		СпособОповещения = НастройкиЛентыНовостей.СпособОповещения;
	КонецЕсли;

	Если СпособОповещения = Перечисления.СпособыОповещенияПользователяОНовостях.СистемаВзаимодействия Тогда
		ТребуетПрочтения = Ложь;
	Иначе
		Если (Объект.ДатаЗавершения = '00010101')
				ИЛИ (Объект.ДатаЗавершения > лкТекущаяУниверсальнаяДата) Тогда // Новость еще актуальна?
			Если (ВажностьНаТекущуюДату = 1)
					ИЛИ (ВажностьНаТекущуюДату = 2)
					ИЛИ (УстановленаВажностьДляКонтекстнойНовости = Истина) Тогда
				ТребуетПрочтения = Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

	Если ПропуститьЧтениеЗаписьПользовательскихНастроекНовости = Истина Тогда
		ПрочтенаПриОткрытии           = Истина;
		ДатаНачалаОповещения          = '00010101';
		ОповещениеВключено            = Ложь;
		Пометка                       = 0;
		ПрочитатьПозже                = 0;
		ОповещениеВключеноПриОткрытии = Ложь;
	Иначе
		// Загрузить из базы состояние новости:
		//  - Прочтена;
		//  - Пометка;
		//  - ПрочитатьПозже;
		//  - ОповещениеВключено (имеет смысл только для важных и очень важных новостей);
		//  - ДатаНачалаОповещения (имеет смысл только для важных и очень важных новостей) // Пока не появится кнопка Отложить, всегда = пустой дате.
		Запись = РегистрыСведений.СостоянияНовостей.СоздатьМенеджерЗаписи();
		Запись.Пользователь = ПараметрыСеанса_ТекущийПользователь;
		Запись.Новость      = Объект.Ссылка;
		Запись.Прочитать(); // Только чтение, без последующей записи.
		Если Запись.Выбран() Тогда
			ПрочтенаПриОткрытии           = Запись.Прочтена; // Для определения (при закрытии формы) - надо ли делать запись в регистр сведений.
			ДатаНачалаОповещения          = Запись.ДатаНачалаОповещения;
			ОповещениеВключено            = Запись.ОповещениеВключено;
			Пометка                       = Запись.Пометка;
			ПрочитатьПозже                = ?(Запись.ПрочитатьПозже = Истина, 1, 0);
			ОповещениеВключеноПриОткрытии = ОповещениеВключено;
		Иначе
			ПрочтенаПриОткрытии   = Ложь; // Для определения при закрытии - надо ли делать запись в регистр сведений.
			ОповещениеВключеноПриОткрытии = Ложь;
			Если ТребуетПрочтения = Истина Тогда
				Если Объект.АвтоСбросНапоминанияПриПрочтении = Истина Тогда
					ОповещениеВключено = Ложь;
				Иначе
					ОповещениеВключено = Истина;
				КонецЕсли;
			Иначе
				ОповещениеВключено = Ложь;
			КонецЕсли;
			ДатаНачалаОповещения = '00010101';
			Пометка              = 0;
			ПрочитатьПозже       = 0;
		КонецЕсли;
		Прочтена = Истина; // При открытии признак Прочтена = Истина всегда, вне зависимости от сохраненного состояния новости.
		ПометкаПриОткрытии        = Пометка;
		ПрочитатьПозжеПриОткрытии = ПрочитатьПозже;
	КонецЕсли;

	// Если новость уже неактуальна, но была установлена важность, то сбросить признак оповещения.
	Если (Объект.ДатаЗавершения <> '00010101')
			И (Объект.ДатаЗавершения <= лкТекущаяУниверсальнаяДата)
			И (ОповещениеВключено = Истина) Тогда // Новость уже неактуальна, но было включено оповещение.
		ОповещениеВключено = Ложь;
		СостояниеНовостиИзменено = Истина; // Принудительно установить признак, чтобы при закрытии записалось новое состояние.
	КонецЕсли;

	// Если флажок ПриОткрытииСразуПереходитьПоСсылке = Истина и задана ссылка на полный текст новости
	//  в реквизите СсылкаНаПолныйТекстНовости, то не открывать форму, а сразу перейти по ссылке.
	// Причем, ссылка может вести как на внешний сайт, так и на объекты метаданных,
	//  разделы справки и т.п. (если начинается на "1C:" английскими буквами).
	// Подробности см. в ОбработкаНовостейКлиент.ОбработкаНавигационнойСсылки.
	Если Объект.ПриОткрытииСразуПереходитьПоСсылке = Истина Тогда
		Если НЕ ПустаяСтрока(Объект.СсылкаНаПолныйТекстНовости) Тогда
			// Отметить такую новость как прочтенную и сбросить признак оповещения сразу,
			//  т.к. формы для просмотра у этой новости (где можно нажать кнопку "Прочтено" / "Оповещение") нет.
			// Записывать настройки нельзя при работе разделенной конфигурации в неразделенном сеансе.
			Если ПропуститьЧтениеЗаписьПользовательскихНастроекНовости <> Истина Тогда
				ОписательНовости = Новый Структура;
					ОписательНовости.Вставить("НовостьСсылка"       , Объект.Ссылка);
					ОписательНовости.Вставить("Прочтена"            , Истина);
					ОписательНовости.Вставить("Пометка"             , Пометка);
					ОписательНовости.Вставить("ПрочитатьПозже"      , ПрочитатьПозже);
					ОписательНовости.Вставить("ОповещениеВключено"  , Ложь);
					ОписательНовости.Вставить("ДатаНачалаОповещения", '00010101');
				// Настройки не изменялись, поэтому не важно, что туда записывать, главное, чтобы совпадали значения с "*ПриОткрытии".
				ОписательНастроекЛентыНовостей = Новый Структура;
					ОписательНастроекЛентыНовостей.Вставить("ЛентаНовостей"                              , Объект.ЛентаНовостей);
					ОписательНастроекЛентыНовостей.Вставить("ЛентаНовостейСостояниеОповещений"           , -1);
					ОписательНастроекЛентыНовостей.Вставить("ЛентаНовостейСостояниеОповещенийПриОткрытии", -1);
					ОписательНастроекЛентыНовостей.Вставить("ЛентаНовостейСостояниеПодписки"             , -1);
					ОписательНастроекЛентыНовостей.Вставить("ЛентаНовостейСостояниеПодпискиПриОткрытии"  , -1);
				ЗаписатьИзменениеСостояния(
					ОписательНовости,
					ОписательНастроекЛентыНовостей,
					ПараметрыСеанса_ТекущийПользователь);
			КонецЕсли;
			// Прервать открытие формы.
			СтандартнаяОбработка = Ложь;
			Возврат;
		КонецЕсли;
	КонецЕсли;

	// Отображение или галочки "Напоминать об этой новости" (ОповещениеВключено) или кнопок "Больше не показывать", "Показать позже".
	Если ТребуетПрочтения = Истина Тогда
		// Это важная или очень важная новость.
		Если (ПоказыватьКнопкиЗакрытия = Истина) Тогда
			Элементы.СтраницыКнопокНапоминания.ТекущаяСтраница = Элементы.СтраницаНовостьНеТребуетПрочтения;
			Элементы.ДекорацияСдвинутьКнопкиЗакрытия.Видимость = Истина;
			Элементы.ГруппаКнопкиЗакрытия.Видимость = Истина;
			Если ПропуститьЧтениеЗаписьПользовательскихНастроекНовости = Истина Тогда
				// Для администратора системы в модели сервиса показывать только кнопку Закрыть.
				Элементы.КомандаБольшеНеПоказывать.Видимость = Ложь;
				Элементы.КомандаПоказатьПозже.Видимость = Ложь;
				Элементы.КомандаЗакрыть.Видимость = Истина;
				Элементы.КомандаЗакрыть.КнопкаПоУмолчанию = Истина;
			Иначе
				Элементы.КомандаБольшеНеПоказывать.Видимость = Истина;
				Элементы.КомандаПоказатьПозже.Видимость = Истина;
				Элементы.КомандаЗакрыть.Видимость = Ложь;
				Если Объект.АвтоСбросНапоминанияПриПрочтении = Истина Тогда
					Элементы.КомандаБольшеНеПоказывать.КнопкаПоУмолчанию = Истина;
				Иначе
					Элементы.КомандаПоказатьПозже.КнопкаПоУмолчанию = Истина;
				КонецЕсли;
			КонецЕсли;
		Иначе
			Элементы.СтраницыКнопокНапоминания.ТекущаяСтраница = Элементы.СтраницаНовостьТребуетПрочтения;
			Элементы.ДекорацияСдвинутьКнопкиЗакрытия.Видимость = Ложь;
			Элементы.ГруппаКнопкиЗакрытия.Видимость = Ложь;
		КонецЕсли;
	Иначе
		// Это обычная новость.
		Элементы.СтраницыКнопокНапоминания.ТекущаяСтраница = Элементы.СтраницаНовостьНеТребуетПрочтения;
		Если (ПоказыватьКнопкиЗакрытия = Истина) Тогда
			Элементы.ДекорацияСдвинутьКнопкиЗакрытия.Видимость = Истина;
			Элементы.ГруппаКнопкиЗакрытия.Видимость = Истина;
			Элементы.КомандаБольшеНеПоказывать.Видимость = Ложь;
			Элементы.КомандаПоказатьПозже.Видимость = Ложь;
			Элементы.КомандаЗакрыть.Видимость = Истина;
			Элементы.КомандаЗакрыть.КнопкаПоУмолчанию = Истина;
		Иначе
			Элементы.ДекорацияСдвинутьКнопкиЗакрытия.Видимость = Ложь;
			Элементы.ГруппаКнопкиЗакрытия.Видимость = Ложь;
		КонецЕсли;
	КонецЕсли;

	ОсновнойШрифтНадписей = ШрифтыСтиля.ОбычныйШрифтТекста;
	ЭтоОбязательныйКанал = Объект.ЛентаНовостей.ОбязательныйКанал;

	// Текст новости.
	ТекстНовости       = ОбработкаНовостейПовтИсп.ПолучитьХТМЛТекстНовостей(Объект.Ссылка);
	Заголовок          = Объект.Наименование;
	ИдентификаторМеста = Параметры.ИдентификаторМеста;

	ЭтотОбъект.ЛентаНовостейСостояниеОповещений = 0; // ПоУмолчанию.
	ЭтотОбъект.ЛентаНовостейСостояниеПодписки   = 0; // Подписано.
	НастройкиЛентНовостей = ХранилищаНастроек.НастройкиНовостей.Загрузить(
		"ЛентыНовостейВсеНастройки",
		Объект.ЛентаНовостей,
		,
		ОбработкаНовостейПовтИсп.ПолучитьИмяПользователяИБ(ПараметрыСеанса_ТекущийПользователь));
	Если (НастройкиЛентНовостей.Количество() = 1) Тогда
		НастройкиЛентыНовостей = НастройкиЛентНовостей[0];
		Если НастройкиЛентыНовостей.СпособОповещения = Перечисления.СпособыОповещенияПользователяОНовостях.Отключено Тогда
			ЭтотОбъект.ЛентаНовостейСостояниеОповещений = 1; // Отключено.
		КонецЕсли;
		Если (НастройкиЛентыНовостей.ПодпискаПринудительно = "Отписан")
				ИЛИ (НастройкиЛентыНовостей.ПодпискаСамостоятельно = "Отписан") Тогда
			ЭтотОбъект.ЛентаНовостейСостояниеПодписки = 1;
		КонецЕсли;
	КонецЕсли;
	ЭтотОбъект.ЛентаНовостейСостояниеОповещенийПриОткрытии = ЭтотОбъект.ЛентаНовостейСостояниеОповещений;
	ЭтотОбъект.ЛентаНовостейСостояниеПодпискиПриОткрытии   = ЭтотОбъект.ЛентаНовостейСостояниеПодписки;

	ИнтеграцияПодсистемБИП.ДополнительноОбработатьФормуНовостиПриСозданииНаСервере(
		ЭтотОбъект,
		Отказ,
		СтандартнаяОбработка);
	ОбработкаНовостейПереопределяемый.ДополнительноОбработатьФормуНовостиПриСозданииНаСервере(
		ЭтотОбъект,
		Отказ,
		СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	ВсеОповещения = ОбработкаНовостейКлиент.ВсеОповещения();

	// Если ПриОткрытииСразуПереходитьПоСсылке = Истина и задана ссылка
	//  на полный текст новости в реквизите СсылкаНаПолныйТекстНовости, то не открывать форму, а сразу перейти по ссылке.
	// Причем, ссылка может вести как на внешний сайт, так и на объекты метаданных,
	//  разделы справки и т.п. (если начинается на "1C:" английскими буквами).
	// Подробности см. в ОбработкаНовостейКлиент.ОбработкаНавигационнойСсылки.
	НавигационнаяСсылка = Объект.СсылкаНаПолныйТекстНовости;
	Если Объект.ПриОткрытииСразуПереходитьПоСсылке = Истина Тогда
		Если НЕ ПустаяСтрока(НавигационнаяСсылка) Тогда

			// Некоторые браузеры (например, FF33) добавляют полный адрес к параметру href и тогда вместо "1C:Act001" получается "http://ПутьКБазе/1C:Act001".
			Если СтрНайти(ВРег(НавигационнаяСсылка), ВРег("http")) = 1 Тогда
				ГдеРазделитель1С = СтрНайти(ВРег(НавигационнаяСсылка), ВРег("/1C:"));
				Если ГдеРазделитель1С > 0 Тогда // 1C - "С" - английская
					НавигационнаяСсылка = Прав(НавигационнаяСсылка, СтрДлина(НавигационнаяСсылка) - ГдеРазделитель1С);
				КонецЕсли;
			КонецЕсли;

			ОповеститьИВыйти = Ложь;
			Если СтрНайти(ВРег(НавигационнаяСсылка), ВРег("http")) = 1 Тогда
				ОбработкаНовостейКлиент.ПерейтиПоИнтернетСсылке(НавигационнаяСсылка);
				ОповеститьИВыйти = Истина;
			ИначеЕсли СтрНайти(ВРег(НавигационнаяСсылка), ВРег("e1c://")) = 1 Тогда
				ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(НавигационнаяСсылка);
				ОповеститьИВыйти = Истина;
			ИначеЕсли СтрНайти(ВРег(НавигационнаяСсылка), ВРег("e1cib/")) = 1 Тогда
				ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(НавигационнаяСсылка);
				ОповеститьИВыйти = Истина;
			ИначеЕсли СтрНайти(ВРег(НавигационнаяСсылка), ВРег("1C:")) = 1 Тогда // 1C - "С" - английская
				// Запустить ОбработкаНавигационнойСсылки с параметрами.
				Действие = "";
				СписокПараметров = Неопределено;
				ОбработкаНовостейВызовСервера.ПодготовитьПараметрыНавигационнойСсылки(Объект.Ссылка, НавигационнаяСсылка, Действие, СписокПараметров);
				ОбработкаНовостейКлиент.ОбработкаНавигационнойСсылки(Объект.Ссылка, Неопределено, Действие, СписокПараметров);
				ОповеститьИВыйти = Истина;
			Иначе
				ТекстСообщения = НСтр("ru='Неизвестная ссылка: %НавигационнаяСсылка%'");
				ТекстСообщения = СтрЗаменить(ТекстСообщения, "%НавигационнаяСсылка%", НавигационнаяСсылка);
				ПоказатьПредупреждение(
					, // ОписаниеОповещенияОЗавершении
					ТекстСообщения,
					0,
					НСтр("ru='Ошибка'")); 
			КонецЕсли;

			Если ОповеститьИВыйти = Истина Тогда
				Отказ = Истина;
				// В регистре сведений "СостоянияНовостей" признак прочтенности уже записан в ПриСозданиинаСервере.
				// Необходимо оповестить, чтобы новость перерисовалась в других формах.
				Оповестить(
					ВсеОповещения.НовостьПрочтена,
					Истина,
					Объект.Ссылка);
				Возврат;
			КонецЕсли;

		КонецЕсли;
	КонецЕсли;

	ЭтотОбъект.ПодключитьОбработчикОжидания("Подключаемый_АктивизироватьФорму", 0.2, Истина);

	УправлениеФормойНаКлиенте();

КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)

	Если ЗавершениеРаботы = Истина Тогда
		// Запрещены серверные вызовы и открытие форм.
		// В таком исключительном случае, когда выходят из программы,
		//  можно проигнорировать установку признака прочтенности у новостей.
	Иначе

		// Если включено разделение данных, и мы зашли в неразделенном сеансе,
		//  то нельзя устанавливать пользовательские свойства новости.
		// Определить, как мы зашли, можно по отключенной командной панели.
		Если Элементы.ГруппаКоманднаяПанель.Видимость = Ложь Тогда
			Возврат;
		КонецЕсли;

		Если Прочтена <> ПрочтенаПриОткрытии Тогда
			СостояниеНовостиИзменено = Истина;
			Оповестить(
				ВсеОповещения.НовостьПрочтена,
				Прочтена,
				Объект.Ссылка);
		КонецЕсли;

		Если ТребуетПрочтения = Истина Тогда
			Если ОповещениеВключено <> ОповещениеВключеноПриОткрытии Тогда
				СостояниеНовостиИзменено = Истина;
				Оповестить(
					ВсеОповещения.ИзмененоСостояниеОповещенияНовости,
					ОповещениеВключено,
					Объект.Ссылка);
				// Для новостей с изменившимся признаком Оповещение очистить кэш контекстных новостей.
				// Причем не имеет значения - включили признак, или выключили.
				Для Каждого ПараметрыКонтекстнойНовости Из Объект.ПривязкаКМетаданным Цикл
					ОбработкаНовостейКлиент.УдалитьКонтекстныеНовостиИзКэшаПриложения(
						ПараметрыКонтекстнойНовости.Метаданные,
						ПараметрыКонтекстнойНовости.Форма);
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;

		Если Пометка <> ПометкаПриОткрытии Тогда
			СостояниеНовостиИзменено = Истина;
			МассивНовостей = Новый Массив;
			МассивНовостей.Добавить(Объект.Ссылка);
			Оповестить(
				ВсеОповещения.ИзмененаПометкаСпискаНовостей,
				Пометка,
				МассивНовостей);
		КонецЕсли;

		Если ПрочитатьПозже <> ПрочитатьПозжеПриОткрытии Тогда
			СостояниеНовостиИзменено = Истина;
			МассивНовостей = Новый Массив;
			МассивНовостей.Добавить(Объект.Ссылка);
			Оповестить(
				ВсеОповещения.ИзмененПризнакПрочитатьПозже,
				?(ПрочитатьПозже = 1, Истина, Ложь),
				МассивНовостей);
		КонецЕсли;

		СостояниеНастроекЛентыНовостейИзменено = Ложь;
		Если (ЛентаНовостейСостояниеОповещений <> ЛентаНовостейСостояниеОповещенийПриОткрытии) Тогда
			СостояниеНастроекЛентыНовостейИзменено = Истина;
			Если ЛентаНовостейСостояниеОповещений = 0 Тогда // ПоУмолчанию.
				// {При добавлении способов оповещения исправлять здесь}.
				Параметр = Новый Структура;
					Параметр.Вставить("Значение"      , "ПоУмолчанию");
					Параметр.Вставить("ЛентаНовостей" , Объект.ЛентаНовостей);
					Параметр.Вставить("Источник"      , "Справочник.Новости.Форма.ФормаНовости");
					Параметр.Вставить("ИсточникУИН"   , ЭтотОбъект.УникальныйИдентификатор);
					Параметр.Вставить("СохранятьВБазе", Ложь);
				Оповестить(
					ВсеОповещения.ИзмененоСостояниеОповещенияЛентыНовостей,
					Параметр,
					ЭтотОбъект.УникальныйИдентификатор); // Идентификатор.
			ИначеЕсли ЛентаНовостейСостояниеОповещений = 1 Тогда // Отключено.
				// {При добавлении способов оповещения исправлять здесь}.
				Параметр = Новый Структура;
					Параметр.Вставить("Значение"      , "Отключено");
					Параметр.Вставить("ЛентаНовостей" , Объект.ЛентаНовостей);
					Параметр.Вставить("Источник"      , "Справочник.Новости.Форма.ФормаНовости");
					Параметр.Вставить("ИсточникУИН"   , ЭтотОбъект.УникальныйИдентификатор);
					Параметр.Вставить("СохранятьВБазе", Ложь);
				Оповестить(
					ВсеОповещения.ИзмененоСостояниеОповещенияЛентыНовостей,
					Параметр,
					ЭтотОбъект.УникальныйИдентификатор); // Идентификатор.
			КонецЕсли;
		КонецЕсли;
		Если (ЛентаНовостейСостояниеПодписки <> ЛентаНовостейСостояниеПодпискиПриОткрытии) Тогда
			СостояниеНастроекЛентыНовостейИзменено = Истина;
			Если ЛентаНовостейСостояниеПодписки = 0 Тогда // Подписан.
				Параметр = Новый Структура;
					Параметр.Вставить("Значение"      , Истина);
					Параметр.Вставить("ЛентаНовостей" , Объект.ЛентаНовостей);
					Параметр.Вставить("Источник"      , "Справочник.Новости.Форма.ФормаНовости");
					Параметр.Вставить("ИсточникУИН"   , ЭтотОбъект.УникальныйИдентификатор);
					Параметр.Вставить("СохранятьВБазе", Ложь);
				Оповестить(
					ВсеОповещения.ИзмененоСостояниеПодпискиНаЛентуНовостей,
					Параметр,
					ЭтотОбъект.УникальныйИдентификатор); // Идентификатор.
			ИначеЕсли ЛентаНовостейСостояниеПодписки = 1 Тогда // Отписан.
				Параметр = Новый Структура;
					Параметр.Вставить("Значение"      , Ложь);
					Параметр.Вставить("ЛентаНовостей" , Объект.ЛентаНовостей);
					Параметр.Вставить("Источник"      , "Справочник.Новости.Форма.ФормаНовости");
					Параметр.Вставить("ИсточникУИН"   , ЭтотОбъект.УникальныйИдентификатор);
					Параметр.Вставить("СохранятьВБазе", Ложь);
				Оповестить(
					ВсеОповещения.ИзмененоСостояниеПодпискиНаЛентуНовостей,
					Параметр,
					ЭтотОбъект.УникальныйИдентификатор); // Идентификатор.
			КонецЕсли;
		КонецЕсли;

		Если (СостояниеНовостиИзменено = Истина)
				ИЛИ (СостояниеНастроекЛентыНовостейИзменено = Истина) Тогда
			Если НЕ ПараметрыСеанса_ТекущийПользователь.Пустая() Тогда
				ОписательНовости = Новый Структура;
					ОписательНовости.Вставить("НовостьСсылка"       , Объект.Ссылка);
					ОписательНовости.Вставить("Прочтена"            , Прочтена);
					ОписательНовости.Вставить("Пометка"             , Пометка);
					ОписательНовости.Вставить("ПрочитатьПозже"      , ПрочитатьПозже);
					ОписательНовости.Вставить("ОповещениеВключено"  , ОповещениеВключено);
					ОписательНовости.Вставить("ДатаНачалаОповещения", ДатаНачалаОповещения);
				ОписательНастроекЛентыНовостей = Новый Структура;
					ОписательНастроекЛентыНовостей.Вставить("ЛентаНовостей"                              , Объект.ЛентаНовостей);
					ОписательНастроекЛентыНовостей.Вставить("ЛентаНовостейСостояниеОповещений"           , ЛентаНовостейСостояниеОповещений);
					ОписательНастроекЛентыНовостей.Вставить("ЛентаНовостейСостояниеОповещенийПриОткрытии", ЛентаНовостейСостояниеОповещенийПриОткрытии);
					ОписательНастроекЛентыНовостей.Вставить("ЛентаНовостейСостояниеПодписки"             , ЛентаНовостейСостояниеПодписки);
					ОписательНастроекЛентыНовостей.Вставить("ЛентаНовостейСостояниеПодпискиПриОткрытии"  , ЛентаНовостейСостояниеПодпискиПриОткрытии);
				ЗаписатьИзменениеСостояния(
					ОписательНовости,
					ОписательНастроекЛентыНовостей,
					ПараметрыСеанса_ТекущийПользователь);
			КонецЕсли;
		КонецЕсли;

	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	ОбработкаНовостейКлиент.ПросмотрНовости_ОбработкаОповещения(ИмяСобытия, Параметр, Источник, ЭтотОбъект);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТекстНовостиПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)

	лкОбъект = Объект; // При открытии из формы элемента справочника / документа

	ОбработкаНовостейКлиент.ОбработкаНажатияВТекстеНовости(лкОбъект, ДанныеСобытия, СтандартнаяОбработка, ЭтотОбъект, Элемент);

КонецПроцедуры

&НаКлиенте
Процедура ТекстНовостиДокументСформирован(Элемент)

	Если НЕ ПустаяСтрока(ИдентификаторМеста) Тогда
		// АПК:280-выкл В исключении ничего не выводится, чтобы не нагружать пользователя.
		Попытка
			ЭлементЯкорь = Элементы.ТекстНовости.Документ.getElementById(ИдентификаторМеста);
			Если ЭлементЯкорь <> Неопределено Тогда
				// Отображать элемент сверху экрана.
				ЭлементЯкорь.scrollIntoView(Истина); // Не все браузеры поддерживают этот метод.
			КонецЕсли;
		Исключение
			// Не все браузеры поддерживают метод scrollIntoView, наличие которого нет возможности проверить заранее.
		КонецПопытки;
		// АПК:280-вкл
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПометкаНажатие(Элемент, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	Если Пометка > 0 Тогда
		Пометка = 0;
	Иначе
		Пометка = 1;
	КонецЕсли;
	УправлениеФормойНаКлиенте();

КонецПроцедуры

&НаКлиенте
Процедура ПрочитатьПозжеНажатие(Элемент, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	Если ПрочитатьПозже > 0 Тогда
		ПрочитатьПозже = 0;
	Иначе
		ПрочитатьПозже = 1;
	КонецЕсли;
	УправлениеФормойНаКлиенте();

КонецПроцедуры

&НаКлиенте
Процедура ОповещениеВключеноПриИзменении(Элемент)

	УправлениеФормойНаКлиенте();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаБольшеНеПоказывать(Команда)

	ОповещениеВключено = Ложь;
	Закрыть();

КонецПроцедуры

&НаКлиенте
Процедура КомандаПоказатьПозже(Команда)

	ОповещениеВключено = Истина;
	Закрыть();

КонецПроцедуры

&НаКлиенте
Процедура КомандаПодписка(Команда)

	СтандартнаяОбработка = Ложь;
	Если ЛентаНовостейСостояниеПодписки > 0 Тогда // Включить - без вопросов.
		ЛентаНовостейСостояниеПодписки = 0;
		УправлениеФормойНаКлиенте();
	Иначе // Отключить - с вопросом.
		ЗаголовокФормыВвода = НСтр("ru='Отписка от ленты новостей'");
		НаименованиеЛентыНовостей = Новый ФорматированнаяСтрока(СокрЛП(Объект.ЛентаНовостей), Новый Шрифт(ОсновнойШрифтНадписей, , , Истина));
		Если ЭтоОбязательныйКанал = Истина Тогда
			ТекстПредупреждения = Новый Массив;
				ТекстПредупреждения.Добавить(НСтр("ru='Невозможно отписаться от обязательной ленты новостей'"));
				ТекстПредупреждения.Добавить(" [");
				ТекстПредупреждения.Добавить(НаименованиеЛентыНовостей);
				ТекстПредупреждения.Добавить("].");
			ПоказатьПредупреждение(
				,
				Новый ФорматированнаяСтрока(ТекстПредупреждения),
				,
				ЗаголовокФормыВвода);
		Иначе
			ДополнительныеПараметры = Новый Структура;
			ОписаниеОповещения = Новый ОписаниеОповещения("ПослеВыбораОтписатьсяОтЛентыНовостей", ЭтотОбъект, ДополнительныеПараметры);
			ТекстПредупреждения = Новый Массив;
				ТекстПредупреждения.Добавить(НСтр("ru='Отписаться от ленты новостей'"));
				ТекстПредупреждения.Добавить(" ");
				ТекстПредупреждения.Добавить(НаименованиеЛентыНовостей);
				ТекстПредупреждения.Добавить("?");
				ТекстПредупреждения.Добавить(Символы.ПС);
				ТекстПредупреждения.Добавить(Символы.ПС);
				ТекстПредупреждения.Добавить(НСтр("ru='После отписки вы не увидите новости из этой ленты новостей.'"));
				ТекстПредупреждения.Добавить(Символы.ПС);
				ТекстПредупреждения.Добавить(НСтр("ru='Также новости перестанут всплывать в системе и вы можете пропустить важные оповещения.'"));
				ТекстПредупреждения.Добавить(Символы.ПС);
				ТекстПредупреждения.Добавить(Символы.ПС);
				ТекстПредупреждения.Добавить(НСтр("ru='При необходимости всегда можно подписаться снова на эту ленту новостей в форме списка новостей.'"));
			Кнопки = Новый СписокЗначений;
				Кнопки.Добавить("Отписаться", НСтр("ru='Отписаться'"));
				Кнопки.Добавить("Отменить", НСтр("ru='Отменить'"));
			ПоказатьВопрос(
				ОписаниеОповещения,
				Новый ФорматированнаяСтрока(ТекстПредупреждения),
				Кнопки,
				,
				"Отменить",
				ЗаголовокФормыВвода,
				"Отменить");
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура КомандаОповещения(Команда)

	ЗаголовокФормыВвода = НСтр("ru='Отключение оповещений у ленты новостей'");
	НаименованиеЛентыНовостей = Новый ФорматированнаяСтрока(СокрЛП(Объект.ЛентаНовостей), Новый Шрифт(ОсновнойШрифтНадписей, , , Истина));

	СтандартнаяОбработка = Ложь;
	Если ЛентаНовостейСостояниеОповещений > 0 Тогда // Включить - без вопросов. Но если лента была отключена, то все равно оповещений не будет.
		Если ЛентаНовостейСостояниеПодписки = 1 Тогда // Лента новостей уже отключена. Нет смысла включать оповещения.
			ТекстПредупреждения = Новый Массив;
				ТекстПредупреждения.Добавить(НСтр("ru='Вы уже отписаны от ленты новостей'"));
				ТекстПредупреждения.Добавить(" [");
				ТекстПредупреждения.Добавить(НаименованиеЛентыНовостей);
				ТекстПредупреждения.Добавить("].");
				ТекстПредупреждения.Добавить(Символы.ПС);
				ТекстПредупреждения.Добавить(Символы.ПС);
				ТекстПредупреждения.Добавить(НСтр("ru='Никакие новости по ней не будут видны.'"));
			ПоказатьПредупреждение(
				,
				Новый ФорматированнаяСтрока(ТекстПредупреждения),
				,
				ЗаголовокФормыВвода);
			Возврат;
		КонецЕсли;
		ЛентаНовостейСостояниеОповещений = 0; // ПоУмолчанию.
		УправлениеФормойНаКлиенте();
	Иначе // Отключить - с вопросом.
		Если ЭтоОбязательныйКанал = Истина Тогда
			ТекстПредупреждения = Новый Массив;
				ТекстПредупреждения.Добавить(НСтр("ru='Невозможно отключить оповещения у обязательной ленты новостей'"));
				ТекстПредупреждения.Добавить(" ");
				ТекстПредупреждения.Добавить(НаименованиеЛентыНовостей);
				ТекстПредупреждения.Добавить(".");
			ПоказатьПредупреждение(
				,
				Новый ФорматированнаяСтрока(ТекстПредупреждения),
				,
				ЗаголовокФормыВвода);
		Иначе
			ДополнительныеПараметры = Новый Структура;
			ОписаниеОповещения = Новый ОписаниеОповещения("ПослеВыбораОтключитьОповещенияЛентыНовостей", ЭтотОбъект, ДополнительныеПараметры);
			ТекстПредупреждения = Новый Массив;
				ТекстПредупреждения.Добавить(НСтр("ru='Отключить оповещения у ленты новостей'"));
				ТекстПредупреждения.Добавить(" ");
				ТекстПредупреждения.Добавить(НаименованиеЛентыНовостей);
				ТекстПредупреждения.Добавить("?");
				ТекстПредупреждения.Добавить(Символы.ПС);
				ТекстПредупреждения.Добавить(Символы.ПС);
				ТекстПредупреждения.Добавить(НСтр("ru='Вы сможете читать новости в форме списка новостей.'"));
				ТекстПредупреждения.Добавить(Символы.ПС);
				ТекстПредупреждения.Добавить(НСтр("ru='Но новости перестанут всплывать в системе и вы можете пропустить важные оповещения.'"));
				ТекстПредупреждения.Добавить(Символы.ПС);
				ТекстПредупреждения.Добавить(Символы.ПС);
				ТекстПредупреждения.Добавить(НСтр("ru='При необходимости, оповещения всегда можно снова включить в форме списка новостей.'"));
			Кнопки = Новый СписокЗначений;
				Кнопки.Добавить("ОтключитьОповещения", НСтр("ru='Отключить оповещения'"));
				Кнопки.Добавить("Отменить", НСтр("ru='Отменить'"));
			ПоказатьВопрос(
				ОписаниеОповещения,
				Новый ФорматированнаяСтрока(ТекстПредупреждения),
				Кнопки,
				,
				"Отменить",
				ЗаголовокФормыВвода,
				"Отменить");
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Управление видимостью и доступностью элементов формы.
//
&НаКлиенте
Процедура УправлениеФормойНаКлиенте()

	Если Пометка = 0 Тогда
		Элементы.Пометка.Рамка = Новый Рамка(ТипРамкиЭлементаУправления.Выпуклая); // АПК:1347 Стиль для однократного применения не создан.
		Элементы.Пометка.Подсказка = НСтр("ru='Новость не отмечена'");
	Иначе
		Элементы.Пометка.Рамка = Новый Рамка(ТипРамкиЭлементаУправления.Вдавленная); // АПК:1347 Стиль для однократного применения не создан.
		Элементы.Пометка.Подсказка = НСтр("ru='Новость отмечена'");
	КонецЕсли;

	Если ПрочитатьПозже = 0 Тогда
		Элементы.ПрочитатьПозже.Рамка = Новый Рамка(ТипРамкиЭлементаУправления.Выпуклая); // АПК:1347 Стиль для однократного применения не создан.
		Элементы.ПрочитатьПозже.Подсказка = НСтр("ru='Новость не в списке для прочтения'");
	Иначе
		Элементы.ПрочитатьПозже.Рамка = Новый Рамка(ТипРамкиЭлементаУправления.Вдавленная); // АПК:1347 Стиль для однократного применения не создан.
		Элементы.ПрочитатьПозже.Подсказка = НСтр("ru='Прочитать позже'");
	КонецЕсли;

	Если ЛентаНовостейСостояниеПодписки = 0 Тогда
		Элементы.КомандаПодписка.Картинка  = БиблиотекаКартинок.НовостиСостояниеПодпискиВключена;
		Элементы.КомандаПодписка.Заголовок = НСтр("ru='Отписаться от ленты'");
	Иначе
		Элементы.КомандаПодписка.Картинка  = БиблиотекаКартинок.НовостиСостояниеПодпискиОтключена;
		Элементы.КомандаПодписка.Заголовок = НСтр("ru='Подписаться на ленту'");
	КонецЕсли;

	Если ЛентаНовостейСостояниеОповещений = 0 Тогда // ПоУмолчанию.
		Элементы.КомандаОповещения.Картинка  = БиблиотекаКартинок.НовостиОповещенияВключены;
		Элементы.КомандаОповещения.Заголовок = НСтр("ru='Отключить оповещения'");
	Иначе
		Элементы.КомандаОповещения.Картинка  = БиблиотекаКартинок.НовостиОповещенияОтключены;
		Элементы.КомандаОповещения.Заголовок = НСтр("ru='Включить оповещения'");
	КонецЕсли;

	// Отображение или галочки "Напоминать об этой новости" (ОповещениеВключено).
	Если (ТребуетПрочтения = Истина) // Это важная или очень важная новость.
			И (ПоказыватьКнопкиЗакрытия = Ложь) Тогда // Управление напоминанием осуществляется кнопками, а не галочкой. Галочку - не выводить.
		Если (ЛентаНовостейСостояниеПодписки <> 0) ИЛИ (ЛентаНовостейСостояниеОповещений <> 0) Тогда
			// Если оповещения отключены или отписались от ленты новостей, то не имеет смысла выводить галочку.
			Элементы.СтраницыКнопокНапоминания.ТекущаяСтраница = Элементы.СтраницаНовостьНеТребуетПрочтения;
		Иначе
			Элементы.СтраницыКнопокНапоминания.ТекущаяСтраница = Элементы.СтраницаНовостьТребуетПрочтения;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

// Активизирует окно формы, на случай если оно перекрылось другими формами.
//
&НаКлиенте
Процедура Подключаемый_АктивизироватьФорму()

	ЭтотОбъект.Активизировать();

КонецПроцедуры

&НаСервереБезКонтекста
// Процедура записывает регистр сведений "СостоянияНовостей".
//
// Параметры:
//  НовостьСсылка          - СправочникСсылка.Новости;
//  лкПрочтена             - Булево;
//  лкПометка              - Число (1,0);
//  лкПрочитатьПозже       - Число (1,0); // Преобразовать в Булево.
//  лкОповещениеВключено   - Булево;
//  лкДатаНачалаОповещения - Дата;
//  лкТекущийПользователь  - СправочникСсылка.Пользователи.
//
Процедура ЗаписатьИзменениеСостояния(
			Знач ОписательНовости,
			Знач ОписательНастроекЛентыНовостей,
			Знач ТекущийПользователь)

	// Состояние новости.
	Запись = РегистрыСведений.СостоянияНовостей.СоздатьМенеджерЗаписи();
		Запись.Пользователь = ТекущийПользователь;
		Запись.Новость      = ОписательНовости.НовостьСсылка;
	Запись.Прочитать(); // Запись будет ниже. // На тот случай, если были установлены другие свойства.
		// Вдруг новость не выбрана (т.е. ее нет в базе) - перезаполнить менеджер записи и записать.
		Запись.Пользователь         = ТекущийПользователь;
		Запись.Новость              = ОписательНовости.НовостьСсылка;
		Запись.Прочтена             = ОписательНовости.Прочтена;
		Запись.Пометка              = ОписательНовости.Пометка;
		Запись.ПрочитатьПозже       = ?(ОписательНовости.ПрочитатьПозже = 1, Истина, Ложь);
		Запись.ОповещениеВключено   = ОписательНовости.ОповещениеВключено;
		Запись.ДатаНачалаОповещения = ОписательНовости.ДатаНачалаОповещения;
	Запись.Записать(Истина);

	// Настройки ленты новостей.
	НеобходимоСброситьКэш = Ложь;
	Если (ОписательНастроекЛентыНовостей.ЛентаНовостейСостояниеПодписки <> ОписательНастроекЛентыНовостей.ЛентаНовостейСостояниеПодпискиПриОткрытии) Тогда
		НеобходимоСброситьКэш = Истина;
		Запись = РегистрыСведений.ОтключенныеЛентыНовостей.СоздатьМенеджерЗаписи();
			Запись.Пользователь  = ТекущийПользователь;
			Запись.ЛентаНовостей = ОписательНастроекЛентыНовостей.ЛентаНовостей;
		Если (ОписательНастроекЛентыНовостей.ЛентаНовостейСостояниеПодписки = 0) Тогда // Подписаться.
			Запись.Удалить();
		ИначеЕсли (ОписательНастроекЛентыНовостей.ЛентаНовостейСостояниеПодписки = 1) Тогда // Отписаться.
			Запись.Записать(Истина);
		КонецЕсли;
	КонецЕсли;

	Если (ОписательНастроекЛентыНовостей.ЛентаНовостейСостояниеОповещений <> ОписательНастроекЛентыНовостей.ЛентаНовостейСостояниеОповещенийПриОткрытии) Тогда
		НеобходимоСброситьКэш = Истина;
		СпособОповещенияПользователяОНовостях = Перечисления.СпособыОповещенияПользователяОНовостях.ПоУмолчанию;
		Если (ОписательНастроекЛентыНовостей.ЛентаНовостейСостояниеОповещений = 1) Тогда // Отключено.
			СпособОповещенияПользователяОНовостях = Перечисления.СпособыОповещенияПользователяОНовостях.Отключено;
		КонецЕсли;
		НастройкиОповещения= Новый Структура;
			НастройкиОповещения.Вставить("КодЛентыНовостей", ""); // Здесь это необязательное поле.
			НастройкиОповещения.Вставить("ЛентаНовостей"   , ОписательНастроекЛентыНовостей.ЛентаНовостей);
			НастройкиОповещения.Вставить("СпособОповещения", СпособОповещенияПользователяОНовостях);
		ОбработкаНовостей.ИзменитьПользовательскиеСпособыОповещенияЛентНовостей(
			ОписательНастроекЛентыНовостей.ЛентаНовостей,
			НастройкиОповещения,
			ТекущийПользователь);
	КонецЕсли;

	Если НеобходимоСброситьКэш = Истина Тогда
		ОбновитьПовторноИспользуемыеЗначения();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПослеВыбораОтписатьсяОтЛентыНовостей(РезультатВопроса, ДополнительныеПараметры) Экспорт

	Если РезультатВопроса = "Отписаться" Тогда
		ЛентаНовостейСостояниеПодписки = 1; // Отключено.
		// После отписки от ленты новостей отключить и оповещения - все равно они не будут поступать.
		ЛентаНовостейСостояниеОповещений = 1;
		УправлениеФормойНаКлиенте();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПослеВыбораОтключитьОповещенияЛентыНовостей(РезультатВопроса, ДополнительныеПараметры) Экспорт

	Если РезультатВопроса = "ОтключитьОповещения" Тогда
		ЛентаНовостейСостояниеОповещений = 1; // Отключено.
		УправлениеФормойНаКлиенте();
	КонецЕсли;

КонецПроцедуры

#КонецОбласти
