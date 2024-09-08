﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	ПроверитьОбработатьПереданныеПараметры(Отказ);
	
	ОбщегоНазначенияСобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если НЕ ПринудительноЗакрытьФорму И Модифицированность Тогда
		
		Отказ = Истина;
		
		СписокКнопок = Новый СписокЗначений;
		СписокКнопок.Добавить(КодВозвратаДиалога.Да, НСтр("ru = 'Сохранить'"));
		СписокКнопок.Добавить(КодВозвратаДиалога.Нет, НСтр("ru = 'Не сохранять'"));
		СписокКнопок.Добавить(КодВозвратаДиалога.Отмена, НСтр("ru = 'Отмена'"));
		
		ПоказатьВопрос(
			Новый ОписаниеОповещения("ПередЗакрытиемВопросЗавершение", ЭтотОбъект),
			НСтр("ru = 'Введенные данные не сохранены, сохранить?'"),
			СписокКнопок);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Проверено(Команда)
	
	ВыполнитьСохранениеРезультата();
	
КонецПроцедуры

&НаКлиенте
Процедура Распределить(Команда)
	
	Для Каждого СтрокаТаблицы Из ДопустимыеСтрокиСопоставления Цикл
		
		Если НеПроверено = 0 Тогда
			Прервать;
		КонецЕсли;
		
		Если (СтрокаТаблицы.ДопустимоеКоличество <= 0) Тогда
			Продолжить;
		КонецЕсли;
		
		ОстатокСтроки = СтрокаТаблицы.ДопустимоеКоличество - СтрокаТаблицы.Количество;
		Распределить = Мин(ОстатокСтроки, НеПроверено);
		
		СтрокаТаблицы.Количество = СтрокаТаблицы.Количество + Распределить;
		НеПроверено = НеПроверено - Распределить;
		Проверено   = Проверено   + Распределить;
		
	КонецЦикла;
	ОбновитьСостояниеПроверки(ЭтаФорма)
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТабличнойЧастиДопустимыеСтрокиСопоставления

&НаКлиенте
Процедура ДопустимыеСтрокиСопоставленияКоличествоПриИзменении(Элемент)
	
	Проверено = ДопустимыеСтрокиСопоставления.Итог("Количество");
	НеПроверено = Количество - Проверено;
	ОбновитьСостояниеПроверки(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ДопустимыеСтрокиСопоставленияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.ДопустимыеСтрокиСопоставления.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если (Поле = Элементы.ДопустимыеСтрокиСопоставленияАлкогольнаяПродукция) Тогда
		ПоказатьЗначение(, ТекущиеДанные.АлкогольнаяПродукция);
	ИначеЕсли (Поле = Элементы.ДопустимыеСтрокиСопоставленияСправка2) И ЗначениеЗаполнено(ТекущиеДанные.Справка2) Тогда
		ПоказатьЗначение(, ТекущиеДанные.Справка2);
	ИначеЕсли (Поле = Элементы.ДопустимыеСтрокиСопоставленияНоменклатура) И ЗначениеЗаполнено(ТекущиеДанные.Номенклатура) Тогда
		ПоказатьЗначение(, ТекущиеДанные.Номенклатура);
	ИначеЕсли (Поле = Элементы.ДопустимыеСтрокиСопоставленияХарактеристика) И ЗначениеЗаполнено(ТекущиеДанные.Характеристика) Тогда
		ПоказатьЗначение(, ТекущиеДанные.Характеристика);
	ИначеЕсли (Поле = Элементы.ДопустимыеСтрокиСопоставленияСерия) И ЗначениеЗаполнено(ТекущиеДанные.Серия) Тогда
		ПоказатьЗначение(, ТекущиеДанные.Серия);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция ПроверитьКорректность()
	
	Результат = Истина;
	
	Если (Проверено = 0) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Таблица сопоставления не заполнена'"));
		Результат = Ложь;
	КонецЕсли;
	
	Если (Проверено > Количество) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Выбранное количество больше требуемого'"));
		Результат = Ложь;
	КонецЕсли;
	
	Для Каждого СтрокаТаблицы Из ДопустимыеСтрокиСопоставления Цикл
		Если ЗначениеЗаполнено(СтрокаТаблицы.ДопустимоеКоличество) И СтрокаТаблицы.Количество > СтрокаТаблицы.ДопустимоеКоличество Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Распределение по справкам 2 ошибочно'"),,
			СтрШаблон("ДопустимыеСтрокиСопоставления[%1].Количество", ДопустимыеСтрокиСопоставления.Индекс(СтрокаТаблицы)));
			Результат = Ложь;
		ИначеЕсли ЭтоСтрокаОстатков = Ложь И СтрокаТаблицы.Количество > СтрокаТаблицы.ДопустимоеКоличество Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Недостаточно фактического остатка'"),,
			СтрШаблон("ДопустимыеСтрокиСопоставления[%1].Количество", ДопустимыеСтрокиСопоставления.Индекс(СтрокаТаблицы)));
			Результат = Ложь;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ПроверитьОбработатьПереданныеПараметры(Отказ)
	
	//Нужно сопоставлять
	Если Параметры.Количество = 0 Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Элементы.ДопустимыеСтрокиСопоставленияХарактеристика.Видимость = ИнтеграцияИС.ХарактеристикиИспользуются();
	Элементы.ДопустимыеСтрокиСопоставленияСерия.Видимость          = ИнтеграцияИС.СерииИспользуются();
	
	Количество           = Параметры.Количество;
	Номенклатура         = Параметры.Номенклатура;
	Характеристика       = Параметры.Характеристика;
	Серия                = Параметры.Серия;
	АлкогольнаяПродукция = Параметры.АлкогольнаяПродукция;
	Справка2             = Параметры.Справка2;
	ЕдиницаИзмерения     = Параметры.ЕдиницаИзмерения;
	
	Если НЕ ЗначениеЗаполнено(ЕдиницаИзмерения) Тогда
		ЕдиницаИзмерения = НСтр("ru = 'ед.'")
	КонецЕсли;
	
	Если НЕ Параметры.Свойство("ЭтоСтрокаУчетныхДанных", ЭтоСтрокаОстатков) Тогда //выбор партий
		Заголовок = НСтр("ru = 'Распределение отрицательного остатка в Регистре №2 ЕГАИС по партиям (справкам №2) в наличии'");
		Элементы.ДопустимыеСтрокиСопоставленияНоменклатура.Видимость = Ложь;
		Элементы.ДопустимыеСтрокиСопоставленияХарактеристика.Видимость = Ложь;
		Элементы.ДопустимыеСтрокиСопоставленияСерия.Видимость = Ложь;
		Элементы.ГруппаАлкогольнаяПродукция.Видимость = Ложь;
		ОписаниеОстатка = НСтр("ru = 'Требуется для Регистра №2'");
		Элементы.ДопустимыеСтрокиСопоставленияДопустимоеКоличество.Заголовок = НСтр("ru = 'Регистр №1'");
		Элементы.УчетныеРеквизитыШапки.Видимость = Ложь;
	ИначеЕсли ЭтоСтрокаОстатков Тогда //выбор алкогольной продукции
		Заголовок = НСтр("ru = 'Распределение учетного остатка по партиям алкогольной продукции ЕГАИС'");
		Элементы.ДопустимыеСтрокиСопоставленияНоменклатура.Видимость = Ложь;
		Элементы.ДопустимыеСтрокиСопоставленияХарактеристика.Видимость = Ложь;
		Элементы.ДопустимыеСтрокиСопоставленияСерия.Видимость = Ложь;
		ОписаниеОстатка = НСтр("ru = 'Остаток на складе'");
		Элементы.ДопустимыеСтрокиСопоставленияДопустимоеКоличество.Заголовок = НСтр("ru = 'Регистры ЕГАИС'");
		Элементы.АлкогольныеРеквизитыШапки.Видимость = Ложь;
	Иначе //выбор номенклатуры
		Заголовок = НСтр("ru = 'Распределение остатка ЕГАИС по товарам на складе'");
		Элементы.УчетныеРеквизитыШапки.Видимость = Ложь;
		Элементы.ГруппаАлкогольнаяПродукция.Видимость = Ложь;
		Элементы.ГруппаСправка2.Видимость = Ложь;
		Если ЗначениеЗаполнено(Справка2) Тогда
			ОписаниеОстатка = НСтр("ru = 'Остаток в регистре №1'");
		Иначе
			ОписаниеОстатка = НСтр("ru = 'Остаток в регистре №2'");
		КонецЕсли;
		Элементы.ДопустимыеСтрокиСопоставленияДопустимоеКоличество.Заголовок = НСтр("ru = 'В наличии'");
	КонецЕсли;
	
	Элементы.Номенклатура.Видимость         = ЗначениеЗаполнено(Номенклатура);
	Элементы.Характеристика.Видимость       = ЗначениеЗаполнено(Характеристика);
	Элементы.Серия.Видимость                = ЗначениеЗаполнено(Серия);
	Элементы.АлкогольнаяПродукция.Видимость = ЗначениеЗаполнено(АлкогольнаяПродукция);
	Элементы.Справка2.Видимость             = ЗначениеЗаполнено(Справка2);
	
	Для Каждого ДопустимоеСопоставление Из Параметры.ДопустимыеСтрокиСопоставления Цикл
		ЗаполнитьЗначенияСвойств(ДопустимыеСтрокиСопоставления.Добавить(), ДопустимоеСопоставление);
	КонецЦикла;
	
	ИтогПоСтрокам = ДопустимыеСтрокиСопоставления.Итог("ДопустимоеКоличество");
	Проверено     = 0;
	НеПроверено   = Количество;
	
	Если ДопустимыеСтрокиСопоставления.Итог("ДопустимоеКоличество") = Количество Тогда
		Для Каждого СтрокаТаблицы Из ДопустимыеСтрокиСопоставления Цикл
			СтрокаТаблицы.Количество = СтрокаТаблицы.ДопустимоеКоличество;
		КонецЦикла;
		Проверено   = Количество;
		НеПроверено = 0;
	ИначеЕсли (ДопустимыеСтрокиСопоставления.Количество() = 1) Тогда
		Если ЭтоСтрокаОстатков = Истина Тогда
			КоличествоВСтроку = Количество;
		Иначе
			КоличествоВСтроку = Мин(Количество,ДопустимыеСтрокиСопоставления[0].ДопустимоеКоличество);
		КонецЕсли;
		ДопустимыеСтрокиСопоставления[0].Количество = КоличествоВСтроку;
		Проверено   = КоличествоВСтроку;
		НеПроверено = Количество - КоличествоВСтроку;
	КонецЕсли;
	
	Элементы.ФормаРаспределить.Видимость = Количество > 0;
	
	ОбновитьСостояниеПроверки(ЭтотОбъект);
	
КонецПроцедуры


&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	ЦветТекстаПроблемаГосИС = ЦветаСтиля.ЦветТекстаПроблемаГосИС;
	
	// Выбранное количество
	ЭлементОформления = УсловноеОформление.Элементы.Добавить();
	ЭлементОформления.Использование = Истина;
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветТекстаПроблемаГосИС);
	ПолеЭлемента = ЭлементОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("ДопустимыеСтрокиСопоставленияКоличество");
	
	ОтборЭлемента = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДопустимыеСтрокиСопоставления.ДопустимоеКоличество");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Меньше;
	ОтборЭлемента.ПравоеЗначение = Новый ПолеКомпоновкиДанных("ДопустимыеСтрокиСопоставления.Количество");
	ОтборЭлемента.Использование = Истина;
	
	ОтборЭлемента = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДопустимыеСтрокиСопоставления.Справка2");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	ОтборЭлемента.Использование = Истина;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьСостояниеПроверки(Форма)
	
	ЗаголовокКоличества = СтрШаблон("%1 %2 %3. ", Форма.ОписаниеОстатка, Форма.Количество, Форма.ЕдиницаИзмерения);
	
	ЕстьОшибкиВСтроках = Ложь;
	Для Каждого СтрокаТаблицы Из Форма.ДопустимыеСтрокиСопоставления Цикл
		Если (ЗначениеЗаполнено(СтрокаТаблицы.Справка2)
			И СтрокаТаблицы.Справка2 <> Форма.Справка2
			И СтрокаТаблицы.Количество > СтрокаТаблицы.ДопустимоеКоличество) Тогда
			ЕстьОшибкиВСтроках = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если ЕстьОшибкиВСтроках Тогда
		Форма.Элементы.СостояниеПроверки.Заголовок = Новый ФорматированнаяСтрока(
			ЗаголовокКоличества,
			Новый ФорматированнаяСтрока(НСтр("ru = 'Неправильно распределены остатки по справкам 2.'"),,Форма.ЦветТекстаПроблемаГосИС));
	ИначеЕсли Форма.НеПроверено = 0 Тогда
		Форма.Элементы.СостояниеПроверки.Заголовок = Новый ФорматированнаяСтрока(
			ЗаголовокКоличества,
			Новый ФорматированнаяСтрока(НСтр("ru = 'Рекомендуется завершить проверку.'")));
	ИначеЕсли Форма.НеПроверено < 0 Тогда
		Форма.Элементы.СостояниеПроверки.Заголовок = Новый ФорматированнаяСтрока(
			ЗаголовокКоличества,
			Новый ФорматированнаяСтрока(НСтр("ru = 'Неправильно распределены остатки по общему количеству.'"),,Форма.ЦветТекстаПроблемаГосИС));
	Иначе
		ЗаголовокДействия = СтрШаблон(НСтр("ru = 'Осталось проверить %1 %2.'"), Форма.НеПроверено, Форма.ЕдиницаИзмерения);
		Форма.Элементы.СостояниеПроверки.Заголовок = Новый ФорматированнаяСтрока(
			ЗаголовокКоличества,
			Новый ФорматированнаяСтрока(ЗаголовокДействия,,Форма.ЦветТекстаПроблемаГосИС),
			?(НЕ Форма.Проверено,"",
				Новый ФорматированнаяСтрока(НСтр("ru = ' Можно подтвердить количество частично.'"))));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемВопросЗавершение(ОтветНаВопрос, ДополнительныеПараметры) Экспорт
	
	Если ОтветНаВопрос = КодВозвратаДиалога.Да Тогда
		
		ВыполнитьСохранениеРезультата();
		
	ИначеЕсли ОтветНаВопрос = КодВозвратаДиалога.Нет Тогда
		
		ПринудительноЗакрытьФорму = Истина;
		Закрыть();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьСохранениеРезультата()
	
	Если ПроверитьКорректность() = Ложь Тогда
		Возврат;
	КонецЕсли;
	
	ИтогПоСтрокам = ДопустимыеСтрокиСопоставления.Итог("Количество");
	СтруктураВозврата = Новый Структура;
	СтруктураВозврата.Вставить("Остаток", Количество - ИтогПоСтрокам);
	РезультатСопоставления = Новый Массив;
	Для Каждого СтрокаКСопоставлению Из ДопустимыеСтрокиСопоставления Цикл
		Если ЗначениеЗаполнено(СтрокаКСопоставлению.Количество) Тогда
			ДанныеСтроки = Новый Структура;
			ДанныеСтроки.Вставить("ИдентификаторСтроки", СтрокаКСопоставлению.ИдентификаторСтроки);
			ДанныеСтроки.Вставить("Количество", СтрокаКСопоставлению.Количество);
			ДанныеСтроки.Вставить("ДобавитьСтроку", СтрокаКСопоставлению.Количество <> СтрокаКСопоставлению.ДопустимоеКоличество);
			РезультатСопоставления.Добавить(ДанныеСтроки);
		КонецЕсли;
	КонецЦикла;
	СтруктураВозврата.Вставить("РезультатСопоставления", РезультатСопоставления);
	Модифицированность = Ложь;
	ОповеститьОВыборе(СтруктураВозврата);
	
КонецПроцедуры

#КонецОбласти

