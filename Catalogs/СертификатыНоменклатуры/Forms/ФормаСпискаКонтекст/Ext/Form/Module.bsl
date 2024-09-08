﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("Номенклатура",Номенклатура);
	ВидНоменклатуры = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Номенклатура,"ВидНоменклатуры");
	
	ТекстЗаголовка = НСтр("ru = 'Сертификаты номенклатуры (%Владелец%)'");
	ТекстЗаголовка = СтрЗаменить(ТекстЗаголовка, "%Владелец%", Строка(Номенклатура));
	
	АвтоЗаголовок = Ложь;
	Заголовок     = ТекстЗаголовка;
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		СертификатыНоменклатуры,
		"ВидНоменклатуры",
		ВидНоменклатуры);
		
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		СертификатыНоменклатуры,
		"Номенклатура",
		Номенклатура);
	
	Если ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Номенклатура,"ИспользованиеХарактеристик") =
		Перечисления.ВариантыИспользованияХарактеристикНоменклатуры.НеИспользовать Тогда
		Элементы.СертификатыНоменклатурыХарактеристика.Видимость = Ложь;
	КонецЕсли;
	
	Если Не ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидНоменклатуры,"ИспользоватьСерии") Тогда
		Элементы.СертификатыНоменклатурыСерия.Видимость = Ложь;
	КонецЕсли;
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СертификатыНоменклатурыСоздать",
			"Видимость", ПравоДоступа("Добавление", Метаданные.Справочники.СертификатыНоменклатуры));
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СертификатыНоменклатурыСкопировать",
			"Видимость", ПравоДоступа("Добавление", Метаданные.Справочники.СертификатыНоменклатуры));
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СертификатыНоменклатурыИзменить",
			"Видимость", ПравоДоступа("Изменение", Метаданные.Справочники.СертификатыНоменклатуры));
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СертификатыНоменклатурыПометитьНаУдаление",
			"Видимость", ПравоДоступа("ИнтерактивнаяПометкаУдаления", Метаданные.Справочники.СертификатыНоменклатуры));
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ПодобратьСертификаты",
			"Видимость", ПравоДоступа("Редактирование", Метаданные.Справочники.СертификатыНоменклатуры));
	
	МассивТипов = Справочники.СертификатыНоменклатуры.СформироватьСписокВыбораТиповСертификатов();
	Элементы.ТипСертификата.СписокВыбора.ЗагрузитьЗначения(МассивТипов);
	
	Если ТолькоДействующиеНаДату Тогда
		Элементы.Дата.Доступность = Истина;
	Иначе
		Элементы.Дата.Доступность = Ложь;
	КонецЕсли;
	
	Дата = ТекущаяДатаСеанса();
	
	НоменклатураЛокализация.ПриСозданииНаСервере_СертификатыНоменклатуры_ФормаСписка(ЭтотОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.КоманднаяПанель = Элементы.КоманднаяПанельСертификатыНоменклатуры;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	СобытияФорм.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_СертификатНоменклатуры" Тогда
		
		МассивТипов = СформироватьСписокВыбораТиповСертификатов();
		Элементы.ТипСертификата.СписокВыбора.ЗагрузитьЗначения(МассивТипов);
		Элементы.СертификатыНоменклатуры.Обновить();
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТипСертификатаПриИзменении(Элемент)
			
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		СертификатыНоменклатуры,
		"ТипСертификата",
		ТипСертификата,
		ВидСравненияКомпоновкиДанных.Равно,,
		ЗначениеЗаполнено(ТипСертификата));
			
КонецПроцедуры

&НаКлиенте
Процедура ТипСертификатаАвтоПодбор(Элемент, Текст, ДанныеВыбора, Параметры, Ожидание, СтандартнаяОбработка)
	
	МассивТипов = СформироватьСписокТипов(Текст);
	ДанныеВыбора = Новый СписокЗначений;
	ДанныеВыбора.ЗагрузитьЗначения(МассивТипов);

КонецПроцедуры

&НаКлиенте
Процедура ТолькоДействующиеНаДатуПриИзменении(Элемент)
	
	Если ТолькоДействующиеНаДату Тогда
		Элементы.Дата.Доступность = Истина;
	Иначе	
		Элементы.Дата.Доступность = Ложь;
	КонецЕсли;
	
	УстановитьОтборПоТолькоДействующимНаДату();	
		
КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	УстановитьОтборПоТолькоДействующимНаДату();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииРеквизитаФормы(Элемент)
	
	НоменклатураКлиентЛокализация.ПриИзмененииРеквизита_СертификатыНоменклатуры_ФормаСписка(Элемент, ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСертификатыНоменклатуры

&НаКлиенте
Процедура СертификатыНоменклатурыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если НоменклатураКлиентЛокализация.ВыборСтатусРосаккредитации(Поле, Элементы) Тогда
		НоменклатураКлиентЛокализация.ПриВыбореСтатусРосаккредитации(Элемент, СтандартнаяОбработка);
	Иначе
		ОбщегоНазначенияУТКлиент.ИзменитьЭлемент(Элемент);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатыНоменклатурыПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатыНоменклатурыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	
	Если Копирование Тогда
		СертификатыНоменклатурыСкопировать(Неопределено);
	Иначе
		СертификатыНоменклатурыСоздать(Неопределено);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатыНоменклатурыПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	СертификатыНоменклатурыИзменить(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатыНоменклатурыПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	СертификатыНоменклатурыПометитьНаУдаление(Неопределено);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УстановитьСтатусДействующий(Команда)
	
	НоменклатураКлиент.УстановитьСтатусСертификатовНоменклатуры(
		ЭтотОбъект,
		Элементы.СертификатыНоменклатуры,
		ПредопределенноеЗначение("Перечисление.СтатусыСертификатовНоменклатуры.Действующий"));
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусНеДействующий(Команда)
	
	НоменклатураКлиент.УстановитьСтатусСертификатовНоменклатуры(
		ЭтотОбъект,
		Элементы.СертификатыНоменклатуры,
		ПредопределенноеЗначение("Перечисление.СтатусыСертификатовНоменклатуры.Недействующий"));
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатыНоменклатурыСоздать(Команда)
	
	ПараметрыФормы = Новый Структура();	
	ПараметрыФормы.Вставить("Номенклатура", Номенклатура);
	ПараметрыФормы.Вставить("ТипСертификата", ТипСертификата);	
	
	ОткрытьФорму("Справочник.СертификатыНоменклатуры.Форма.ФормаЭлемента", ПараметрыФормы, ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура СертификатыНоменклатурыСкопировать(Команда)

	ТекущаяСтрока = Элементы.СертификатыНоменклатуры.ТекущиеДанные;
	Если ТекущаяСтрока <> Неопределено Тогда	
		ПараметрыФормы = Новый Структура("ЗначениеКопирования", ТекущаяСтрока.Ссылка);
		ОткрытьФорму("Справочник.СертификатыНоменклатуры.ФормаОбъекта", ПараметрыФормы);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СертификатыНоменклатурыИзменить(Команда)
	
	ТекущаяСтрока = Элементы.СертификатыНоменклатуры.ТекущиеДанные;
	Если ТекущаяСтрока <> Неопределено Тогда	
		ПараметрыФормы = Новый Структура("Ключ", ТекущаяСтрока.Ссылка);
		ОткрытьФорму("Справочник.СертификатыНоменклатуры.ФормаОбъекта", ПараметрыФормы);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатыНоменклатурыПометитьНаУдаление(Команда)
	
	ТекущаяСтрока = Элементы.СертификатыНоменклатуры.ТекущиеДанные;
	Если ТекущаяСтрока <> Неопределено Тогда	
		
		ШаблонВопроса = ?(ТекущаяСтрока.ПометкаУдаления,
			НСтр("ru = 'Снять с ""%1"" пометку на удаление?'"),
			НСтр("ru = 'Пометить ""%1"" на удаление?'"));
		ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		ШаблонВопроса,
		ТекущаяСтрока.Ссылка);
		
		ПоказатьВопрос(Новый ОписаниеОповещения("СертификатыНоменклатурыПометитьНаУдалениеЗавершение", ЭтотОбъект, Новый Структура("ТекущаяСтрока", ТекущаяСтрока)), ТекстВопроса, РежимДиалогаВопрос.ДаНет, 60, КодВозвратаДиалога.Да);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодобратьСертификаты(Команда)
	
	ОткрытьФорму("Справочник.СертификатыНоменклатуры.Форма.ФормаПодбораСертификатов", Новый Структура ("Номенклатура", Номенклатура));
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьИзображение(Команда)
	
	ОчиститьСообщения();
	
	ТекущаяСтрока = Элементы.СертификатыНоменклатуры.ТекущиеДанные;
	
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураВозврата = ОткрытьИзображениеНаСервере(ТекущаяСтрока.Ссылка);	

	Если СтруктураВозврата.Результат = "НетИзображений" Тогда
		ТекстСообщения = НСтр("ru='Для сертификата номенклатуры ""%Сертификат%"" отсутствует изображение для просмотра'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения,"%Сертификат%",ТекущаяСтрока.Ссылка);
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);	
	ИначеЕсли СтруктураВозврата.Результат = "ОдноИзображение" Тогда
		РаботаСФайламиКлиент.ОткрытьФайл(
			РаботаСФайламиСлужебныйВызовСервера.ПолучитьДанныеФайла(
			СтруктураВозврата.ПрисоединенныйФайл,
			УникальныйИдентификатор));
	Иначе
		ПараметрыВыбора		= Новый Структура("ВладелецФайла, ЗакрыватьПриВыборе, РежимВыбора",
												ТекущаяСтрока.Ссылка, Истина, Истина);
		ОписаниеОповещения	= Новый ОписаниеОповещения("ОткрытьИзображениеЗавершение", ЭтотОбъект);
		
		ОткрытьФорму("Обработка.РаботаСФайлами.Форма.ПрисоединенныеФайлы",
					ПараметрыВыбора,
					,
					,
					,
					,
					ОписаниеОповещения,
					РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьКомандуФормы(Команда)
	
	НоменклатураКлиентЛокализация.ВыполнитьКоманду_СертификатыНоменклатуры_ФормаСписка(Команда, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтотОбъект, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СертификатыНоменклатурыХарактеристика.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СертификатыНоменклатуры.Характеристика");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаОтмененнойСтрокиДокумента);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<для всех характеристик>'"));

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СертификатыНоменклатурыСерия.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СертификатыНоменклатуры.Серия");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаОтмененнойСтрокиДокумента);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<для всех серий>'"));

	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СертификатыНоменклатурыДатаОкончанияСрокаДействия.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СертификатыНоменклатуры.Бессрочный");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
		
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаОтмененнойСтрокиДокумента);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<бессрочный>'"));
	
	//
	НоменклатураЛокализация.УстановитьУсловноеОформлениеСпискаСертификатовНоменклатуры(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборПоТолькоДействующимНаДату()
	
	ИспользованиеОтбора = ТолькоДействующиеНаДату
							И ЗначениеЗаполнено(Дата);
	
	ГруппаОтборПоДействующимНаДату = ОбщегоНазначенияКлиентСервер.СоздатьГруппуЭлементовОтбора(
										ОбщегоНазначенияУТКлиентСервер.ПолучитьОтборДинамическогоСписка(СертификатыНоменклатуры).Элементы,
										"ГруппаОтборПоДействующимНаДату",
										ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаОтборПоДействующимНаДату,
														"Статус",
														ПредопределенноеЗначение("Перечисление.СтатусыСертификатовНоменклатуры.Действующий"),
														ВидСравненияКомпоновкиДанных.Равно,
														"ОтборПоСтатусу",
														ИспользованиеОтбора);
	
	ГруппаОтборПоДате = ОбщегоНазначенияКлиентСервер.СоздатьГруппуЭлементовОтбора(
							ГруппаОтборПоДействующимНаДату,
							"ГруппаОтборПоДате",
							ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли);
	
	ГруппаОтборПоСрокуДействия = ОбщегоНазначенияКлиентСервер.СоздатьГруппуЭлементовОтбора(
									ГруппаОтборПоДате,
									"ГруппаОтборПоСрокуДействия",
									ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаОтборПоСрокуДействия,
														"ДатаНачалаСрокаДействия",
														Дата,
														ВидСравненияКомпоновкиДанных.МеньшеИлиРавно,
														"ОтборПоДатеНачалаСрокаДействия",
														ИспользованиеОтбора);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаОтборПоСрокуДействия,
														"ДатаОкончанияСрокаДействия",
														Дата,
														ВидСравненияКомпоновкиДанных.БольшеИлиРавно,
														"ОтборПоДатеОкончанияСрокаДействия",
														ИспользованиеОтбора);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаОтборПоДате,
														"Бессрочный",
														Истина,
														ВидСравненияКомпоновкиДанных.Равно,
														"ОтборПоДатеБессрочный",
														ИспользованиеОтбора);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПометкуУдаленияСертификата(СертификатСсылка, Пометка)
	
	СертификатОбъект = СертификатСсылка.ПолучитьОбъект();
	СертификатОбъект.УстановитьПометкуУдаления(Пометка);	
	СертификатОбъект.Записать();
	
КонецПроцедуры

// Параметры:
// 	РезультатВопроса - КодВозвратаДиалога - 
// 	ДополнительныеПараметры - Структура - содержит:
//		* ТекущаяСтрока - ДанныеФормыСтруктура - 
&НаКлиенте
Процедура СертификатыНоменклатурыПометитьНаУдалениеЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	ТекущаяСтрока = ДополнительныеПараметры.ТекущаяСтрока;
	
	Ответ = РезультатВопроса; 
	Если Ответ <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПометкуУдаленияСертификата(ТекущаяСтрока.Ссылка,Не ТекущаяСтрока.ПометкаУдаления);
	Элементы.СертификатыНоменклатуры.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьИзображениеЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ЗначениеВыбора = Результат;
	
	Если ЗначениеЗаполнено(ЗначениеВыбора) Тогда
		РаботаСФайламиКлиент.ОткрытьФайл(
			РаботаСФайламиСлужебныйВызовСервера.ПолучитьДанныеФайла(
			ЗначениеВыбора,
			УникальныйИдентификатор));
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ОткрытьИзображениеНаСервере(СертификатНоменклатуры);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	МАКСИМУМ(СертификатыНоменклатурыПрисоединенныеФайлы.Ссылка) КАК ПрисоединенныйФайл,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ СертификатыНоменклатурыПрисоединенныеФайлы.Ссылка) КАК КоличествоФайлов,
	|	СертификатыНоменклатурыПрисоединенныеФайлы.ВладелецФайла
	|ИЗ
	|	Справочник.СертификатыНоменклатурыПрисоединенныеФайлы КАК СертификатыНоменклатурыПрисоединенныеФайлы
	|ГДЕ
	|	СертификатыНоменклатурыПрисоединенныеФайлы.ВладелецФайла = &ВладелецФайла
	|	И СертификатыНоменклатурыПрисоединенныеФайлы.ПометкаУдаления = ЛОЖЬ
	|
	|СГРУППИРОВАТЬ ПО
	|	СертификатыНоменклатурыПрисоединенныеФайлы.ВладелецФайла";
	Запрос.УстановитьПараметр("ВладелецФайла", СертификатНоменклатуры);
	
	Выборка = Запрос.Выполнить().Выбрать();

	СтруктураВозврата = Новый Структура;
	
	Если Выборка.Следующий() Тогда
		Если Выборка.КоличествоФайлов > 1 Тогда
			СтруктураВозврата.Вставить("Результат", "МассивИзображений");
		ИначеЕсли Выборка.КоличествоФайлов = 1 Тогда
			СтруктураВозврата.Вставить("Результат", 			"ОдноИзображение");
			СтруктураВозврата.Вставить("ПрисоединенныйФайл",	Выборка.ПрисоединенныйФайл);
		КонецЕсли;
	Иначе
		СтруктураВозврата.Вставить("Результат", "НетИзображений");
	КонецЕсли;
	
	Возврат СтруктураВозврата;
	
КонецФункции

&НаСервереБезКонтекста
Функция СформироватьСписокТипов(Текст)
	
	Возврат Справочники.СертификатыНоменклатуры.АвтоПодборТиповСертификатов(Текст);
	
КонецФункции

&НаСервереБезКонтекста
Функция СформироватьСписокВыбораТиповСертификатов()
	
	Возврат Справочники.СертификатыНоменклатуры.СформироватьСписокВыбораТиповСертификатов();
	
КонецФункции

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.СертификатыНоменклатуры);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.СертификатыНоменклатуры, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.СертификатыНоменклатуры);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти
