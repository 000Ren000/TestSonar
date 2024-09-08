﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	УстановитьУсловноеОформление();
	
	УстановитьЗаголовки();
	
	// Обработчик подсистемы запрета редактирования реквизитов объектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);
	
	Если Объект.Ссылка.Пустая() Тогда
		ПриСозданииЧтенииНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриСозданииЧтенииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если НЕ УдалятьСозданныеСообщения Тогда
		Объект.СрокХраненияСообщений = 0;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// Обработчик подсистемы запрета редактирования реквизитов объектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);
	НастроитьПанельНавигации();
	УправлениеДоступностью(ЭтотОбъект);
	Элементы.СтраницаОписание.Картинка = ОбщегоНазначенияКлиентСервер.КартинкаКомментария(Объект.Описание);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ИсточникВыбора.ИмяФормы = "Справочник.ГруппыРассылокИОповещений.Форма.ФормаВыбораУчетнойЗаписи" Тогда
		
		Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
			
			Объект.УчетнаяЗапись               = ВыбранноеЗначение.УчетнаяЗапись;
			УчетнаяЗаписьНеХранитПисьма        = ВыбранноеЗначение.УдалятьПослеОтправки;
			УчетнаяЗаписьНедоступнаДляОтправки = Ложь;
			УправлениеДоступностью(ЭтаФорма);
			
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.Партнеры")
		И Не ВыбранноеЗначение.Пустая() Тогда
		
		РассылкиИОповещенияКлиентамКлиент.ОткрытьФормуПодписки(ВыбранноеЗначение, Объект.Ссылка, ЭтотОбъект);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_НастройкиОтправкиSMS" Тогда
		ПроверитьНастройкуSMS();
	ИначеЕсли ИмяСобытия = "Запись_УчетныеЗаписиЭлектроннойПочты" Тогда
		ПроверитьДоступныеУчетныеЗаписи();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если УдалятьСозданныеСообщения И Объект.СрокХраненияСообщений = 0 Тогда
		ТекстСообщения = НСтр("ru = 'Не указан срок хранения сообщений.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,"Объект.СрокХраненияСообщений",,Отказ);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПредназначенаДляЭлектронныхПисемПриИзменении(Элемент)
	
	УправлениеДоступностью(ЭтотОбъект);
	ЗаполнитьВидыКИПоУмолчанию();
	
КонецПроцедуры

&НаКлиенте
Процедура УдалятьСозданныеСообщенияПриИзменении(Элемент)
	
	УправлениеДоступностью(ЭтотОбъект);
	ОтключитьОтметкуНезаполненного();
	
КонецПроцедуры

&НаКлиенте
Процедура УчетнаяЗаписьНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьФорму("Справочник.ГруппыРассылокИОповещений.Форма.ФормаВыбораУчетнойЗаписи", ,ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредназначенаДляSMSПриИзменении(Элемент)
	
	УправлениеДоступностью(ЭтотОбъект);
	ЗаполнитьВидыКИПоУмолчанию();
	
КонецПроцедуры

&НаКлиенте
Процедура ТипПодпискиПриИзменении(Элемент)
	
	Объект.Принудительная = ?(ТипПодписки = 0, Ложь, Истина);
	ЗаполнитьВидыКИПоУмолчанию();
	УправлениеВидимостью();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправлятьКонтактнымЛицамРолиПриИзменении(Элемент)
	
	ЗаполнитьВидыКИПоУмолчанию();
	УправлениеДоступностью(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправлятьПартнеруПриИзменении(Элемент)
	
	ЗаполнитьВидыКИПоУмолчанию();
	УправлениеДоступностью(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправлятьКонтактномуЛицуОбъектаОповещенияПриИзменении(Элемент)
	
	ЗаполнитьВидыКИПоУмолчанию();
	УправлениеДоступностью(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)
	
	ОбщегоНазначенияУТКлиент.РазрешитьРедактированиеРеквизитовОбъекта(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьОтправкуSMS(Команда)
	
	ОткрытьФорму("ОбщаяФорма.НастройкаОтправкиSMS");
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьУчетныеЗаписиЭлектроннойПочты(Команда)
	
	ОткрытьФорму("Справочник.УчетныеЗаписиЭлектроннойПочты.ФормаСписка");
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПодписку(Команда)
	
	ОткрытьФорму("Справочник.Партнеры.ФормаВыбора", , ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьРассылку(Команда)
	
	ЗначенияЗаполнения = Новый Структура;
	ЗначенияЗаполнения.Вставить("ГруппаРассылокИОповещений", Объект.Ссылка);
	ПараметрыФормы = Новый Структура("ЗначенияЗаполнения", ЗначенияЗаполнения);
	
	ОткрытьФорму("Документ.РассылкаКлиентам.ФормаОбъекта", ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьВидОповещения(Команда)
	
	ЗначенияЗаполнения = Новый Структура;
	ЗначенияЗаполнения.Вставить("ГруппаРассылокИОповещений", Объект.Ссылка);
	ПараметрыФормы = Новый Структура("ЗначенияЗаполнения", ЗначенияЗаполнения);
	
	ОткрытьФорму("Справочник.ВидыОповещенийКлиентам.ФормаОбъекта", ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриСозданииЧтенииНаСервере()
	
	ПравоЧтенияУчетныеЗаписи = ПравоДоступа("Чтение", Метаданные.Справочники.УчетныеЗаписиЭлектроннойПочты);
	
	ЗаполнитьСпискиВыбораВидаКИ();
	НастройкаSMSВыполнена = ОтправкаSMS.НастройкаОтправкиSMSВыполнена();
	ЗаполнитьДоступныеУчетныеЗаписи();
	
	Если ЗначениеЗаполнено(Объект.УчетнаяЗапись) 
		И ДоступныеДляОтправкиУчетныеЗаписи.НайтиСтроки(Новый Структура("УчетнаяЗапись", Объект.УчетнаяЗапись)).Количество() = 0 Тогда
		
		УчетнаяЗаписьНедоступнаДляОтправки = Истина;
		
	КонецЕсли;
	
	УдалятьСозданныеСообщения = (Объект.СрокХраненияСообщений > 0);
	ТипПодписки = ?(Объект.Принудительная,1,0);
	
	УправлениеВидимостью();
	НастроитьПанельНавигации();
	Элементы.СтраницаОписание.Картинка = ОбщегоНазначенияКлиентСервер.КартинкаКомментария(Объект.Описание);
	
КонецПроцедуры

&НаСервере
Процедура НастроитьПанельНавигации()
	
	СтруктураНастроек = Новый Структура;
	СтруктураНастроек.Вставить("ИспользоватьДанныеПодписок", НЕ Объект.Принудительная);
	
	ОбщегоНазначенияУТ.НастроитьФормуПоПараметрам(ЭтотОбъект, СтруктураНастроек);
	
КонецПроцедуры

&НаСервере
Процедура УправлениеВидимостью()
	
	Элементы.СоздатьРассылку.Видимость = ПравоДоступа("Добавление", Метаданные.Документы.РассылкаКлиентам);
	Элементы.СоздатьВидОповещения.Видимость = ПравоДоступа("Добавление", Метаданные.Справочники.ВидыОповещенийКлиентам);
	Элементы.СоздатьПодписку.Видимость      = ПравоДоступа("Добавление", Метаданные.Справочники.ПодпискиНаРассылкиИОповещенияКлиентам);
	
	ИспользоватьПрочиеВзаимодействия = ПолучитьФункциональнуюОпцию("ИспользоватьПрочиеВзаимодействия");
	
	Элементы.ГруппаУчетныеЗаписиНеНастроены.Видимость         = НЕ ЕстьДоступныеУчетныеЗаписи;
	Элементы.УчетнаяЗапись.Доступность                        = ПравоЧтенияУчетныеЗаписи;
	Элементы.НастроитьУчетныеЗаписиЭлектроннойПочты.Видимость = ПравоЧтенияУчетныеЗаписи;
	
	Элементы.ГруппаSMS.Видимость                      = ИспользоватьПрочиеВзаимодействия;
	Элементы.ГруппаSMSНеНастроены.Видимость           = ИспользоватьПрочиеВзаимодействия 
	                                                    И Не НастройкаSMSВыполнена 
	                                                    И ПравоДоступа("Просмотр", Метаданные.ОбщиеФормы.НастройкаОтправкиSMS);
	
	Элементы.ГруппаНастройкиАдресатовПринудительно.Видимость = Объект.Принудительная;
	Элементы.ДекорацияВидПодпискиПояснение.Заголовок  = ТекстПоясненияТипРассылки(Объект.Принудительная);
	
	Элементы.ДекорацияКонтактноеЛицоПартнераПояснение.Заголовок = РассылкиИОповещенияКлиентам.ТекстПоясненияКонтактноеЛицоОбъектаОповещения();
	
	УправлениеДоступностью(ЭтотОбъект);

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ТекстПоясненияТипРассылки(Принудительная)

	Если НЕ Принудительная Тогда
		ТекстПояснения = НСтр("ru = 'Рассылки и оповещения будут отправляться согласно настройкам подписок. Виды контактной информации,
		                             |указанные в данной форме, будут использованы как значения по умолчанию и могут быть 
		                             |изменены при оформлении подписок.'");
	Иначе
		ТекстПояснения = НСтр("ru = 'Рассылки и оповещения будут отправляться принудительно. Настройка подписок невозможна. В данной форме
		                             |необходимо настроить, кто будет получателем сообщений и виды контактной информации, согласно
		                             |которым будут определяться адреса электронной почты и номера телефонов адресатов.'");
	КонецЕсли;
	
	Возврат ТекстПояснения;

КонецФункции 

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеДоступностью(Форма)
	
	ТребуетсяНастройкаКИКонтактногоЛица = ТребуетсяНастройкаКИКонтактногоЛица(Форма.Объект);
	ТребуетсяНастройкаКИПартнера        = ТребуетсяНастройкаКИПартнера(Форма.Объект);
	ОбъектЗаписан                       = НЕ Форма.Объект.Ссылка.Пустая();
	
	Форма.Элементы.УчетнаяЗапись.Доступность                                  = Форма.Объект.ПредназначенаДляЭлектронныхПисем
	                                                                            И Форма.ПравоЧтенияУчетныеЗаписи;
	Форма.Элементы.ВидКонтактнойИнформацииПартнераДляПисем.Доступность        = Форма.Объект.ПредназначенаДляЭлектронныхПисем
	                                                                            И ТребуетсяНастройкаКИПартнера;
	Форма.Элементы.ВидКонтактнойИнформацииКонтактногоЛицаДляПисем.Доступность = Форма.Объект.ПредназначенаДляЭлектронныхПисем
	                                                                            И ТребуетсяНастройкаКИКонтактногоЛица;
	Форма.Элементы.НастроитьУчетныеЗаписиЭлектроннойПочты.Доступность         = Форма.Объект.ПредназначенаДляЭлектронныхПисем;
	
	Форма.Элементы.ВидКонтактнойИнформацииПартнераДляSMS.Доступность          = Форма.Объект.ПредназначенаДляSMS
	                                                                            И ТребуетсяНастройкаКИПартнера;
	Форма.Элементы.ВидКонтактнойИнформацииКонтактногоЛицаДляSMS.Доступность   = Форма.Объект.ПредназначенаДляSMS
	                                                                            И ТребуетсяНастройкаКИКонтактногоЛица;
	Форма.Элементы.НастроитьОтправкуSMS.Доступность                           = Форма.Объект.ПредназначенаДляSMS;
	
	Форма.Элементы.СрокХраненияСообщений.Доступность  = Форма.УдалятьСозданныеСообщения;
	Если Форма.УчетнаяЗаписьНедоступнаДляОтправки Или Не Форма.ПравоЧтенияУчетныеЗаписи Тогда
		Форма.Элементы.СтраницыУчетнаяЗапись.ТекущаяСтраница = Форма.Элементы.СтраницаУчетнаяЗаписьНедоступна;
	Иначе
		Форма.Элементы.СтраницыУчетнаяЗапись.ТекущаяСтраница = Форма.Элементы.СтраницаУчетнаяЗаписьДоступна;
	КонецЕсли;
	
	Форма.Элементы.РольКонтактногоЛица.Доступность = Форма.Объект.ОтправлятьКонтактнымЛицамРоли;
	
	Форма.Элементы.СоздатьРассылку.Доступность      = ОбъектЗаписан;
	Форма.Элементы.СоздатьВидОповещения.Доступность = ОбъектЗаписан;
	Форма.Элементы.СоздатьПодписку.Доступность      = ОбъектЗаписан И НЕ Форма.Объект.Принудительная;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

#Область СрокХраненияСообщений
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СрокХраненияСообщений.Имя);
	
	ГруппаОтбора = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;

	ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("УдалятьСозданныеСообщения");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.СрокХраненияСообщений");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;

	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
	
#КонецОбласти
	
КонецПроцедуры

&НаСервере
Функция ЗаполнитьСпискиВыбораВидаКИ()
	
	СтруктураСписковВыбора = РассылкиИОповещенияКлиентам.СтруктураСписковВыбораКИ();
	
	РассылкиИОповещенияКлиентам.СкопироватьЗначенияСпискаЗначений(
	     Элементы.ВидКонтактнойИнформацииПартнераДляПисем.СписокВыбора,
	     СтруктураСписковВыбора.ПартнерыАдресЭлектроннойПочты);
	
	РассылкиИОповещенияКлиентам.СкопироватьЗначенияСпискаЗначений(
	     Элементы.ВидКонтактнойИнформацииПартнераДляSMS.СписокВыбора,
	     СтруктураСписковВыбора.ПартнерыТелефон);
	
	РассылкиИОповещенияКлиентам.СкопироватьЗначенияСпискаЗначений(
	     Элементы.ВидКонтактнойИнформацииКонтактногоЛицаДляПисем.СписокВыбора,
	     СтруктураСписковВыбора.КонтактныеЛицаАдресЭлектроннойПочты);
	
	РассылкиИОповещенияКлиентам.СкопироватьЗначенияСпискаЗначений(
	     Элементы.ВидКонтактнойИнформацииКонтактногоЛицаДляSMS.СписокВыбора,
	     СтруктураСписковВыбора.КонтактныеЛицаТелефон);
		 
	Элементы.ВидКонтактнойИнформацииПартнераДляПисем.КнопкаВыбора        = (Элементы.ВидКонтактнойИнформацииПартнераДляПисем.СписокВыбора.Количество() > 1);
	Элементы.ВидКонтактнойИнформацииПартнераДляSMS.КнопкаВыбора          = (Элементы.ВидКонтактнойИнформацииПартнераДляSMS.СписокВыбора.Количество() > 1);
	Элементы.ВидКонтактнойИнформацииКонтактногоЛицаДляПисем.КнопкаВыбора = (Элементы.ВидКонтактнойИнформацииКонтактногоЛицаДляПисем.СписокВыбора.Количество() > 1);
	Элементы.ВидКонтактнойИнформацииКонтактногоЛицаДляSMS.КнопкаВыбора   = (Элементы.ВидКонтактнойИнформацииКонтактногоЛицаДляSMS.СписокВыбора.Количество() > 1);

КонецФункции

&НаСервере
Процедура ПроверитьНастройкуSMS()
	
	НастройкаSMSВыполнена = ОтправкаSMS.НастройкаОтправкиSMSВыполнена();
	УправлениеВидимостью();
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьДоступныеУчетныеЗаписи()

	ЗаполнитьДоступныеУчетныеЗаписи();
	УправлениеВидимостью();

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДоступныеУчетныеЗаписи()

	ДоступныеДляОтправкиУчетныеЗаписи.Очистить();
	
	Если ПравоЧтенияУчетныеЗаписи Тогда
		УправлениеЭлектроннойПочтой.ПолучитьДоступныеУчетныеЗаписиДляОтправки(
		Элементы.УчетнаяЗапись.СписокВыбора, ДоступныеДляОтправкиУчетныеЗаписи);
		ЕстьДоступныеУчетныеЗаписи = ДоступныеДляОтправкиУчетныеЗаписи.Количество() > 0;
	Иначе
		ЕстьДоступныеУчетныеЗаписи = Ложь;
		Элементы.ДекорацияОшибкаУчетнаяЗапись.Подсказка = НСтр("ru = 'У вас нет прав на чтение учетных записей электронной почты, обратитесь к администратору.'");
	КонецЕсли;

КонецПроцедуры 

&НаКлиенте
Процедура ЗаполнитьВидыКИПоУмолчанию()

	ТребуетсяНастройкаКИКонтактногоЛица = ТребуетсяНастройкаКИКонтактногоЛица(Объект);
	ТребуетсяНастройкаКИПартнера        = ТребуетсяНастройкаКИПартнера(Объект);
	
	Если Объект.ПредназначенаДляSMS Тогда
		
		Если Объект.ВидКонтактнойИнформацииПартнераДляSMS.Пустая()
			И ТребуетсяНастройкаКИПартнера
			И Элементы.ВидКонтактнойИнформацииПартнераДляSMS.СписокВыбора.Количество() = 1 Тогда
			
			Объект.ВидКонтактнойИнформацииПартнераДляSMS =
			       Элементы.ВидКонтактнойИнформацииПартнераДляSMS.СписокВыбора.Получить(0).Значение;
			
		КонецЕсли;
		
		Если Объект.ВидКонтактнойИнформацииКонтактногоЛицаДляSMS.Пустая()
			И ТребуетсяНастройкаКИКонтактногоЛица
			И Элементы.ВидКонтактнойИнформацииКонтактногоЛицаДляSMS.СписокВыбора.Количество() = 1 Тогда
			
			Объект.ВидКонтактнойИнформацииКонтактногоЛицаДляSMS = 
			       Элементы.ВидКонтактнойИнформацииКонтактногоЛицаДляSMS.СписокВыбора.Получить(0).Значение;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если Объект.ПредназначенаДляЭлектронныхПисем Тогда
		
		Если Объект.ВидКонтактнойИнформацииКонтактногоЛицаДляПисем.Пустая()
			И ТребуетсяНастройкаКИКонтактногоЛица
			И Элементы.ВидКонтактнойИнформацииКонтактногоЛицаДляПисем.СписокВыбора.Количество() = 1 Тогда
			
			Объект.ВидКонтактнойИнформацииКонтактногоЛицаДляПисем = 
			       Элементы.ВидКонтактнойИнформацииКонтактногоЛицаДляПисем.СписокВыбора.Получить(0).Значение;
			
		КонецЕсли;
				
		Если Объект.ВидКонтактнойИнформацииПартнераДляПисем.Пустая()
			И ТребуетсяНастройкаКИПартнера
			И Элементы.ВидКонтактнойИнформацииПартнераДляПисем.СписокВыбора.Количество() = 1 Тогда
			
			Объект.ВидКонтактнойИнформацииПартнераДляПисем = 
			       Элементы.ВидКонтактнойИнформацииПартнераДляПисем.СписокВыбора.Получить(0).Значение;
			
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ТребуетсяНастройкаКИКонтактногоЛица(Объект)

	Возврат Не Объект.Принудительная 
	        ИЛИ Объект.ОтправлятьКонтактномуЛицуОбъектаОповещения 
	        ИЛИ Объект.ОтправлятьКонтактнымЛицамРоли;

КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ТребуетсяНастройкаКИПартнера(Объект)

	Возврат НЕ Объект.Принудительная ИЛИ Объект.ОтправлятьПартнеру;

КонецФункции

&НаСервере
Процедура УстановитьЗаголовки()

	ИспользоватьПартнеровКакКонтрагентов = ПолучитьФункциональнуюОпцию("ИспользоватьПартнеровКакКонтрагентов");
	
	ПартнерыИКонтрагенты.ЗаголовокРеквизитаВЗависимостиОтФОИспользоватьПартнеровКакКонтрагентов(
	            ЭтотОбъект, "ОтправлятьПартнеру", НСтр("ru = 'на контактную информацию контрагента'"), ИспользоватьПартнеровКакКонтрагентов);
	ПартнерыИКонтрагенты.ЗаголовокРеквизитаВЗависимостиОтФОИспользоватьПартнеровКакКонтрагентов(
	            ЭтотОбъект, "ВидКонтактнойИнформацииПартнераДляПисем", НСтр("ru = 'для контрагента'"), ИспользоватьПартнеровКакКонтрагентов);
	ПартнерыИКонтрагенты.ЗаголовокРеквизитаВЗависимостиОтФОИспользоватьПартнеровКакКонтрагентов(
	            ЭтотОбъект, "ВидКонтактнойИнформацииПартнераДляSMS", НСтр("ru = 'для контрагента'"), ИспользоватьПартнеровКакКонтрагентов);

КонецПроцедуры

#КонецОбласти
