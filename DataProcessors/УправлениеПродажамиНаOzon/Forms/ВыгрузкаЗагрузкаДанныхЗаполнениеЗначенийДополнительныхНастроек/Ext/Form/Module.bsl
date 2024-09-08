﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Элементы.СтраницаСлужебныеНастройки.Видимость = Ложь;

	УчетнаяЗапись        = Параметры.УчетнаяЗапись;
	СсылкаНаОбъект       = Параметры.СсылкаНаОбъект;
	ИмяОбъектаМетаданных = Параметры.ИмяОбъектаМетаданных;
	ИмяТабличнойЧасти    = Параметры.ИмяТабличнойЧасти;

	ИмяФайлаПоУмолчанию = ИнтеграцияСМаркетплейсамиСервер.СформироватьИмяФайлаДляОбъектаМетаданных(ИмяОбъектаМетаданных
		+ ".ТабличныеЧасти." + ИмяТабличнойЧасти, СсылкаНаОбъект);

	ВариантНастроек = Параметры.ВариантНастроек;
	Если ПустаяСтрока(ВариантНастроек) Тогда
		ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru = 'Открытие формы невозможно по причине: не указан вариант настроек.'"));
		Отказ = Истина;
		Возврат;
	КонецЕсли;

	Если Не ПустаяСтрока(Параметры.ЗаголовокФормы) Тогда
		Заголовок = Параметры.ЗаголовокФормы;
	КонецЕсли;

	ЗаполнитьТаблицуИнформацииПоКолонкам();

	Для Каждого Страница Из Элементы.Страницы.ПодчиненныеЭлементы Цикл
		Страница.Видимость = Ложь;
	КонецЦикла;

	Если ВариантНастроек = "ВыгрузкаЗаявкиНаВозврат" Тогда
		Если Не ЗначениеЗаполнено(СсылкаНаОбъект) Тогда
			Отказ = Истина;
			ОбщегоНазначения.СообщитьПользователю(
				НСтр("ru = 'Не выбран объект для выгрузки данных.'"),, "СсылкаНаОбъект");
			Возврат;
		КонецЕсли;

		Элементы.СтраницаВыгрузкаЗаявкиНаВозврат.Видимость = Истина;
		Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаВыгрузкаЗаявкиНаВозврат;

		ПрисоединенныйФайл = ИнтеграцияСМаркетплейсамиСервер.НайтиПрисоединенныйФайл(СсылкаНаОбъект,
			НаименованиеПрисоединенногоФайла(ВариантНастроек, СсылкаНаОбъект));
		ПрочитатьИЗаполнитьПараметрыИзФайла(ПрисоединенныйФайл);

	ИначеЕсли ВариантНастроек = "ЗагрузкаЗаявкиНаВозврат" Тогда
		Элементы.СтраницаЗагрузкаЗаявкиНаВозврат.Видимость = Истина;
		Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаЗагрузкаЗаявкиНаВозврат;

		Если Не ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоСкладов") Тогда
			Элементы.ДекорацияСкладПриемки.Видимость        = Ложь;
			Элементы.СкладПриемкиЗаявкиНаВывоз.Видимость = Ложь;
		КонецЕсли;

	ИначеЕсли ВариантНастроек = "ЗагрузкаЗаявкиНаПоставку" Тогда
		Элементы.СтраницаЗагрузкаЗаявкиНаПоставку.Видимость = Истина;
		Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаЗагрузкаЗаявкиНаПоставку;

		Если Не ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоСкладов") Тогда
			Элементы.ДекорацияСкладОтгрузки.Видимость        = Ложь;
			Элементы.СкладОтгрузкиЗаявкиНаПоставку.Видимость = Ложь;
		Иначе
			ПродажиСервер.УстановитьРежимВыбораГруппЭлементовСклада(Элементы.СкладОтгрузкиЗаявкиНаПоставку);
		КонецЕсли;

	КонецЕсли;

	ЗаполнитьЗначенияРеквизитовПоУмолчанию(УчетнаяЗапись);
	ЗаполнитьЗначенияРеквизитовИзПараметров();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПрисоединенныйФайлПриИзменении(Элемент)

	ПрочитатьИЗаполнитьПараметрыИзФайла(ПрисоединенныйФайл);

КонецПроцедуры

&НаКлиенте
Процедура ПрисоединенныйФайлНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;

	СтруктураПараметрыВыбора = Новый Структура("ВладелецФайла, ЗакрыватьПриВыборе, РежимВыбора",
		СсылкаНаОбъект, Истина, Истина);
	ОписаниеОповещения = Новый ОписаниеОповещения("ПрисоединенныйФайлВыборЗавершение", ЭтотОбъект);
	
	ОткрытьФорму("Обработка.РаботаСФайлами.Форма.ПрисоединенныеФайлы",
				СтруктураПараметрыВыбора,
				,
				,
				,
				,
				ОписаниеОповещения,
				РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыбратьФайл(Команда)

	ОповещениеЗавершения = Новый ОписаниеОповещения("ВыбратьФайлЗавершение", ЭтотОбъект);

	ПараметрыЗагрузки = ФайловаяСистемаКлиент.ПараметрыЗагрузкиФайла();
	ПараметрыЗагрузки.Диалог.Фильтр = НСтр("ru = 'Все поддерживаемые форматы файлов(*.xls;*.xlsx;*.ods;*.mxl)|*.xls;*.xlsx;*.ods;*.mxl|Книга Excel 97 (*.xls)|*.xls|Книга Excel 2007 (*.xlsx)|*.xlsx|Электронная таблица OpenDocument (*.ods)|*.ods|Табличный документ (*.mxl)|*.mxl'");
	ПараметрыЗагрузки.ИдентификаторФормы = УникальныйИдентификатор;

	ФайловаяСистемаКлиент.ЗагрузитьФайл(ОповещениеЗавершения, ПараметрыЗагрузки, ИмяФайлаПоУмолчанию);

КонецПроцедуры

&НаКлиенте
Процедура Записать(Команда)

	ВозвращаемыеЗначения = Новый Структура;

	Если ВариантНастроек = "ВыгрузкаЗаявкиНаВозврат" Тогда
		ВозвращаемыеЗначения.Вставить("ИдентификаторДоговора", ИдентификаторДоговора);
		ВозвращаемыеЗначения.Вставить("НаименованиеДоговора",  НаименованиеДоговора);
		ВозвращаемыеЗначения.Вставить("ИдентификаторСклада",   ИдентификаторСклада);
		ВозвращаемыеЗначения.Вставить("НаименованиеСклада",    НаименованиеСклада);
		ВозвращаемыеЗначения.Вставить("ПрисоединенныйФайл",    ПрисоединенныйФайл);

	ИначеЕсли ВариантНастроек = "ЗагрузкаЗаявкиНаВозврат" Тогда
		ВозвращаемыеЗначения.Вставить("Склад", Склад);

 	ИначеЕсли ВариантНастроек = "ЗагрузкаЗаявкиНаПоставку" Тогда
		ВозвращаемыеЗначения.Вставить("НомерЗаявкиНаПоставку", НомерЗаявкиНаПоставку);
		ВозвращаемыеЗначения.Вставить("Склад",                 Склад);

	КонецЕсли;

	Закрыть(ВозвращаемыеЗначения);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьТаблицуИнформацииПоКолонкам()

	ИнтеграцияСМаркетплейсамиСервер.ИнициализироватьТаблицуИнформацииПоКолонкам(ЭтотОбъект);

	ИнформацияПоКолонкамТаблица = РеквизитФормыВЗначение("ИнформацияПоКолонкам");

	ПараметрыОбработкиДанных = ИнтеграцияСМаркетплейсамиСервер.ПараметрыЗагрузкиИзФайлаВТабличнуюЧасть();
	ПараметрыОбработкиДанных.ИмяОбъектаМетаданных    = ИмяОбъектаМетаданных;
	ПараметрыОбработкиДанных.ИмяТабличнойЧасти       = ИмяТабличнойЧасти;
	ПараметрыОбработкиДанных.ИмяМакетаСШаблоном      = "ЗагрузкаИзФайлаЗаявкаНаВозврат";

	ИнтеграцияСМаркетплейсамиСервер.ЗаполнитьИнформациюПоЗагружаемымРеквизитам(ПараметрыОбработкиДанных);

	ПараметрыШапки = ИнтеграцияСМаркетплейсамиСервер.ПараметрыШапки();
	ИнтеграцияСМаркетплейсамиСервер.ОпределитьИнформациюПоКолонкамИПараметрамШапки(
		ПараметрыОбработкиДанных,
		ИнформацияПоКолонкамТаблица,
		ПараметрыШапки);

	ЗначениеВРеквизитФормы(ИнформацияПоКолонкамТаблица, "ИнформацияПоКолонкам");

КонецПроцедуры

&НаСервереБезКонтекста
Функция НаименованиеПрисоединенногоФайла(ВариантНастроек, СсылкаНаОбъект)

	Если ВариантНастроек = "ВыгрузкаЗаявкиНаВозврат" Тогда
		НаименованиеПрисоединенногоФайла =
			Обработки.УправлениеПродажамиНаOzon.НаименованиеСохраняемогоФайла(СсылкаНаОбъект);
	Иначе
		НаименованиеПрисоединенногоФайла = "";
	КонецЕсли;

	Возврат НаименованиеПрисоединенногоФайла;

КонецФункции

&НаСервереБезКонтекста
Функция ЗаписатьФайлВПрисоединенныеФайлыНаСервере(Результат, СсылкаНаОбъект, ВариантНастроек)

	ПутьКВыбранномуФайлу     = Результат.Имя;
	АдресВременногоХранилища = Результат.Хранение;
	Расширение               = ОбщегоНазначенияКлиентСервер.РасширениеБезТочки(
		ОбщегоНазначенияКлиентСервер.ПолучитьРасширениеИмениФайла(ПутьКВыбранномуФайлу));

	ПутьКВременномуФайлу = ПолучитьИмяВременногоФайла(Расширение);
	ДвоичныеДанные = ПолучитьИЗВременногоХранилища(АдресВременногоХранилища); // ДвоичныеДанные
	ДвоичныеДанные.Записать(ПутьКВременномуФайлу);

	НаименованиеПрисоединенногоФайла = НаименованиеПрисоединенногоФайла(ВариантНастроек, СсылкаНаОбъект);

	ПрисоединенныйФайл = ИнтеграцияСМаркетплейсамиСервер.ЗаписатьПрисоединенныйФайл(
		СсылкаНаОбъект,
		ПутьКВременномуФайлу,
		ПутьКВыбранномуФайлу,
		НаименованиеПрисоединенногоФайла);

	ФайловаяСистема.УдалитьВременныйФайл(ПутьКВременномуФайлу);

	Возврат ПрисоединенныйФайл;

КонецФункции

&НаКлиенте
Процедура ВыбратьФайлЗавершение(Результат, ДополнительныеПараметры) Экспорт

	Если Результат <> Неопределено Тогда
		ПрисоединенныйФайл = ЗаписатьФайлВПрисоединенныеФайлыНаСервере(Результат, СсылкаНаОбъект, ВариантНастроек);
		ПрочитатьИЗаполнитьПараметрыИзФайла(ПрисоединенныйФайл);

		ПоказатьОповещениеПользователя(
			НСтр("ru = 'Запись файла'"),,
			НСтр("ru = 'Выбранный файл успешно загружен.'"));
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПрисоединенныйФайлВыборЗавершение(Результат, ДополнительныеПараметры) Экспорт

	Если ЗначениеЗаполнено(Результат) Тогда
		ПрисоединенныйФайл = Результат;
		ПрочитатьИЗаполнитьПараметрыИзФайла(ПрисоединенныйФайл);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПрочитатьИЗаполнитьПараметрыИзФайла(ПрисоединенныйФайл)

	Если Не ЗначениеЗаполнено(ПрисоединенныйФайл) Тогда
		Возврат;
	КонецЕсли;

	Если ВариантНастроек = "ВыгрузкаЗаявкиНаВозврат" Тогда
		ИнформацияПоКолонкамТаблица = РеквизитФормыВЗначение("ИнформацияПоКолонкам");
		ИнтеграцияСМаркетплейсамиСервер.ЗаполнитьПараметрыШапкиИзПрисоединенногоФайла(
			ПрисоединенныйФайл,
			ИнформацияПоКолонкамТаблица,
			ПараметрыШапки);

		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ПараметрыШапки.Параметры);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьЗначенияРеквизитовПоУмолчанию(УчетнаяЗапись)

	Если ВариантНастроек = "ЗагрузкаЗаявкиНаВозврат" Или ВариантНастроек = "ЗагрузкаЗаявкиНаПоставку" Тогда
		НастройкиУчетнойЗаписи = Справочники.УчетныеЗаписиМаркетплейсов.НастройкиУчетнойЗаписи(УчетнаяЗапись, Истина);

		ПараметрыОтбора = Новый Структура;
		ПараметрыОтбора.Вставить("ВыбранноеСоглашение", НастройкиУчетнойЗаписи.Соглашение);

		Если ВариантНастроек = "ЗагрузкаЗаявкиНаПоставку" Тогда
			ПараметрыОтбора.Вставить("УчитыватьГруппыСкладов", Истина);
			ПараметрыОтбора.Вставить("ПустаяСсылкаДокумента", Документы.ЗаказКлиента.ПустаяСсылка());
		ИначеЕсли ВариантНастроек = "ЗагрузкаЗаявкиНаПоставку" Тогда
			ПараметрыОтбора.Вставить("ПустаяСсылкаДокумента", Документы.ЗаявкаНаВозвратТоваровОтКлиента.ПустаяСсылка());
			ПараметрыОтбора.Вставить("ХозяйственныеОперации",
				ПродажиСервер.ПолучитьХозяйственнуюОперациюСоглашенияПоВозврату(
					Перечисления.ХозяйственныеОперации.ВозвратОтКомиссионера));
		КонецЕсли;

		УсловияПродажПоУмолчанию = ПродажиСервер.ПолучитьУсловияПродажПоУмолчанию(
			НастройкиУчетнойЗаписи.Партнер,
			ПараметрыОтбора);

		Если УсловияПродажПоУмолчанию <> Неопределено Тогда
			Если ЗначениеЗаполнено(УсловияПродажПоУмолчанию.Склад) Тогда
				Склад = УсловияПродажПоУмолчанию.Склад;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьЗначенияРеквизитовИзПараметров()

	Если ТипЗнч(Параметры.ЗначенияПараметровСсылкиНаОбъект) = Тип("Структура") Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры.ЗначенияПараметровСсылкиНаОбъект);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти
